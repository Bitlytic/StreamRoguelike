class_name Player
extends Entity


@export var debug_draw := false

@export var vision_range := 8

@onready var animation_controller: AnimationController = $AnimationController
@onready var sight_controller: SightController = $SightController
@onready var level_transition_player: AnimationPlayer = $TransitionLayer/LevelTransitionPlayer
@onready var walk_timer: Timer = $WalkTimer

enum AimingMode {
	NONE,
	RANGED,
	INFO,
	WALK
}

var current_aiming_mode := AimingMode.NONE:
	set(val):
		current_aiming_mode = val
		ActionManager.aiming = current_aiming_mode != AimingMode.NONE

var picking_direction := false

var walking := false:
	set(val):
		walking = val
		if walking:
			walk_timer.start()
		else:
			walk_timer.stop()

var walk_target : Vector2i

var current_aiming_position : Vector2i

var positions_to_check : Array[Vector2i]

var last_target : Entity

var in_level_transition := false

var a_star_grid := AStarGrid2D.new()


func _ready():
	health_changed.connect(on_health_changed)
	on_health_changed(health)
	
	a_star_grid.region = Rect2i(Vector2i(0, 0), GridWorld.world_size + Vector2i(1, 1))
	a_star_grid.update()
	
	sight_controller.vision_range = vision_range
	
	add_to_group("player")
	
	register_self()
	
	walk_timer.timeout.connect(on_walk_timer_timeout)


func register_self() -> void:
	level_transition_player.play("fade_in")
	
	grid_position = global_position / GridWorld.cell_size.floor()
	
	GridWorld.add_entity(self)
	
	effects_holder = Node.new()
	add_child(effects_holder)
	
	# TODO: Please fix this one day. This feels really gross
	await get_tree().process_frame
	update_sight()
	await get_tree().process_frame
	GridWorld.world_ready()
	update_sight()


func fade_out(stairs: StairEntity) -> void:
	
	in_level_transition = true
	level_transition_player.play("fade_out")
	await level_transition_player.animation_finished
	GridWorld.player_input(TravelAction.new(stairs))
	in_level_transition = false


func on_walk_timer_timeout() -> void:
	if !walking:
		return
	
	walk_to_target()


func _unhandled_input(event: InputEvent) -> void:
	if in_level_transition:
		return
	
	if event is InputEventMouseMotion:
		_handle_mouse_movement()
	elif event is InputEventMouseButton:
		_handle_mouse_button()
	
	if event is InputEventKey:
		if !event.pressed:
			return
	
	var input_direction : int = Direction.get_player_direction()
	var target_direction := Direction.direction_to_vector2(input_direction)
	
	if walking:
		return
	
	if ActionManager.aiming:
		if (_process_cursor_movement(target_direction)):
			return
	elif ActionManager.is_busy():
		return
	
	if (_process_gui(input_direction, target_direction)):
		return
	
	_process_auto_actions(target_direction)


# Returns true if rest of process should be skipped
# For example, if inventory is opened, we shouldn't be allowed to move in the same step
func _process_gui(input_direction: int, target_direction: Vector2i) -> bool:
	if Input.is_action_pressed("pick_action_menu"):
		picking_direction = true
		ActionManager.show_picking_direction()
	
	if picking_direction:
		var input_center := Input.is_action_pressed("move_wait")
		
		if Input.is_action_pressed("cancel"):
			picking_direction = false
			ActionManager.hide_top_bar()
			return true
		
		if !input_direction && !input_center:
			return true
		
		ActionManager.hide_top_bar()
		
		picking_direction = false
		
		var target_position := grid_position + target_direction
		var cell : GridCell = GridWorld.get_cell(target_position)
		ActionManager.show_dialog(cell, target_position)
		return true
	
	if Input.is_action_pressed("inventory"):
		ActionManager.show_inventory_dialog(inventory)
		return true
	
	if Input.is_action_pressed("equipment"):
		ActionManager.show_equipment_dialog(equipment)
		return true
	
	if Input.is_action_pressed("use_ranged"):
		if !equipment.ranged_weapon:
			return false
		
		set_aiming_mode(AimingMode.RANGED)
		return true
	
	if Input.is_action_pressed("inspect"):
		set_aiming_mode(AimingMode.INFO)
		return true
	
	if Input.is_action_pressed("target_walk"):
		set_aiming_mode(AimingMode.WALK)
		return true
	
	return false


func set_aiming_mode(aiming_mode: int) -> void:
	current_aiming_mode = aiming_mode
	current_aiming_position = grid_position
	
	if last_target && is_instance_valid(last_target) && last_target.in_vision:
		current_aiming_position = last_target.grid_position
	
	GridWorld.show_reticle()
	GridWorld.update_reticle_position(current_aiming_position)
	queue_redraw()
	ActionManager.show_aiming()


func _process_auto_actions(target_direction: Vector2i):
	var action := EntityAction.new()
	
	if target_direction:
		action = _try_move_to(target_direction)
	elif Input.is_action_pressed("move_wait"):
		action.type = ActionType.WAIT
	elif Input.is_action_pressed("next_level"):
		var cell : GridCell = GridWorld.get_cell(grid_position)
		var stairs : StairEntity = cell.get_first_match(Predicates.is_stair_entity)
		if stairs:
			fade_out(stairs)
	
	if action.type != ActionType.NONE:
		GridWorld.player_input(action)


func _process_cursor_movement(target_direction: Vector2i) -> bool:
	if !ActionManager.aiming:
		return false
	
	current_aiming_position += target_direction
	current_aiming_position = GridWorld.clamp_to_bounds(current_aiming_position)
	queue_redraw()
	
	GridWorld.update_reticle_position(current_aiming_position)
	match current_aiming_mode:
		AimingMode.INFO:
			GridWorld.set_tooltip_position(current_aiming_position)
	
	if Input.is_action_just_pressed("cancel"):
		clear_aiming()
	
	if Input.is_action_pressed("ui_accept"):
		accept_aiming()
		return true
	
	return true


func accept_aiming() -> void:
	match current_aiming_mode:
		AimingMode.RANGED:
			attack_ranged_target()
		AimingMode.WALK:
			set_walk_target()
	
	clear_aiming()


func clear_aiming() -> void:
	current_aiming_mode = AimingMode.NONE
	GridWorld.hide_reticle()
	GridWorld.hide_tooltip()
	queue_redraw()
	ActionManager.hide_top_bar()

func _handle_mouse_movement() -> void:
	if ActionManager.aiming:
		var mouse_pos : Vector2 = get_global_mouse_position()
		mouse_pos /= GridWorld.cell_size
		current_aiming_position = mouse_pos
		_process_cursor_movement(Vector2i.ZERO)


func _handle_mouse_button() -> void:
	if current_aiming_mode != AimingMode.NONE:
		if Input.is_action_just_pressed("primary_mouse"):
			accept_aiming()

func play_attack_animation(action: AttackAction):
	var direction = action.target.grid_position - grid_position
	
	direction.x = clamp(direction.x, -1, 1)
	direction.y = clamp(direction.y, -1, 1)
	
	animation_controller.play_attack_animation(Direction.vector2_to_direction(direction))


func on_health_changed(_new_health: int) -> void:
	PlayerEventBus.health_changed.emit(self)


func update_sight():
	sight_controller.vision_range = vision_range
	sight_controller.update_fov()
	
	GridWorld.set_player_vision(sight_controller.visible_tiles)
	
	queue_redraw()


func attack_ranged_target() -> void:
	
	var cell : GridCell = GridWorld.get_cell(current_aiming_position)
	
	if cell.character:
		last_target = cell.character
	else:
		for e in cell.get_entities():
			if !e.is_passable(self):
				last_target = e
				break
	
	var action := AttackAction.new()
	action.weapon = equipment.ranged_weapon
	
	var line_to := PathfindingUtil.get_line_to(grid_position, current_aiming_position)
	
	if line_to.size() < 1:
		return
	
	for pos in line_to:
		cell = GridWorld.get_cell(pos)
		if cell.character && cell.character is not Player:
			action.target = cell.character
			break
		
		for e in cell.get_entities():
			if !e.is_passable(self):
				action.target = e
				break
		
		if action.target:
			break
	
	GridWorld.player_input(action)


func set_walk_target() -> void:
	walking = true
	walk_target = current_aiming_position


func _draw() -> void:
	if !debug_draw:
		return
	
	if current_aiming_mode == AimingMode.RANGED:
		var line_to := PathfindingUtil.get_line_to(grid_position, current_aiming_position)
		
		if line_to.size() < 2:
			return
		
		var scaled_points := []
		
		for pos in line_to:
			scaled_points.append(Vector2(pos - grid_position)*GridWorld.cell_size)
		
		var packed_array := PackedVector2Array(scaled_points)
		
		draw_polyline(scaled_points, Color(1, 1, 1, 0.5), 2.0, true)


func _try_move_to(target_direction: Vector2i) -> EntityAction:
	var action := EntityAction.new()
	
	var action_position := grid_position + target_direction
	
	var cell : GridCell = GridWorld.get_cell(action_position)
	
	if _can_move_to_cell(cell):
		action = MoveAction.new()
		action.position = action_position
	elif cell.character:
		action = AttackAction.new(equipment.weapon, cell.character)
	elif cell.has_any(Predicates.is_door_entity):
		var door : DoorEntity = cell.get_first_match(Predicates.is_door_entity)
		var can_open_door := !door.locked && !door.open
		
		var key_slot := inventory.find_item_slot(ItemRegistry.KEY)
		
		if can_open_door:
			action = OpenAction.new(door)
		elif _can_unlock_door(door, key_slot):
			action = UnlockAction.new(door, key_slot)
	
	return action


func walk_to_target() -> void:
	if can_see_danger():
		walking = false
		return
	
	GridWorld.update_pathfinding(self, a_star_grid, true)
	
	var path := a_star_grid.get_id_path(grid_position, walk_target, true)
	
	path.pop_front()
	
	#TODO: This sometimes messes up when it shouldn't
	if path.size() <= 0:
		walking = false
		return
	
	#TODO: this crashes sometimes
	var target_direction = path[0] - grid_position
	
	var action = _try_move_to(target_direction)
	
	GridWorld.player_input(action)
	
	if grid_position == walk_target:
		walking = false


func can_see_danger() -> bool:
	for tile in sight_controller.visible_tiles:
		var cell : GridCell = GridWorld.get_cell(Vector2i(tile))
		
		if cell.character && cell.character is Enemy:
			return true
	
	return false


func _can_move_to_cell(cell: GridCell) -> bool:
	return !cell || (cell.character == null && !cell.blocks_movement())


func _can_unlock_door(door: DoorEntity, key_slot: ItemSlot) -> bool:
	return door.locked && key_slot != null
