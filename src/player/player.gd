class_name Player
extends Entity


@export var debug_draw := false

@export var vision_range := 12

@onready var weapon : BasicWeapon = axe
@onready var animation_controller: AnimationController = $AnimationController
@onready var sight_controller: SightController = $SightController


var axe : BasicWeapon = load("res://resources/weapons/axe.tres")

var has_moved := false
var picking_direction := false
var aiming_ranged_weapon := false

var current_aiming_position : Vector2i 


var positions_to_check : Array[Vector2i]

func _ready():
	super()
	
	equipment.weapon = weapon
	
	health_changed.connect(on_health_changed)
	on_health_changed(health)
	
	sight_controller.vision_range = vision_range
	
	# TODO: Please fix this one day. This feels really gross
	await get_tree().process_frame
	update_sight()
	await get_tree().process_frame
	GridWorld.world_updated.emit()
	update_sight()


func _physics_process(delta: float) -> void:
	var input_direction : int = Direction.get_player_direction()
	var target_direction := Direction.direction_to_vector2(input_direction)
	
	if Input.is_action_just_pressed("debug_info"):
		print("armor: ", equipment.get_armor())
		print("evasion: ", equipment.get_evasion())
	
	if ActionManager.picking_action || ActionManager.picking_item:
		return
	
	if Input.is_action_just_pressed("pick_action_menu"):
		picking_direction = true
		ActionManager.show_picking_direction()
	
	if Input.is_action_just_pressed("use_ranged"):
		aiming_ranged_weapon = true
		current_aiming_position = grid_position
		GridWorld.show_reticle()
		ActionManager.show_aiming()
	
	if Input.is_action_just_pressed("inventory"):
		ActionManager.show_inventory_dialog(inventory)
		return
	
	if Input.is_action_just_pressed("equipment"):
		ActionManager.show_equipment_dialog(equipment)
		return
	
	if picking_direction:
		var input_center := Input.is_action_just_pressed("move_wait")
		
		if Input.is_action_just_pressed("cancel"):
			picking_direction = false
			ActionManager.hide_top_bar()
			return
		
		if !input_direction && !input_center:
			return
		
		ActionManager.hide_top_bar()
		
		picking_direction = false
		
		var target_position := grid_position + target_direction
		var cell : GridCell = GridWorld.get_cell(target_position)
		ActionManager.show_dialog(cell, target_position)
		return
	
	if aiming_ranged_weapon:
		if target_direction:
			current_aiming_position += target_direction
			current_aiming_position = GridWorld.clamp_to_bounds(current_aiming_position)
			GridWorld.update_reticle_position(current_aiming_position)
			queue_redraw()
		return
	
	var action := EntityAction.new()
	
	if target_direction:
		var action_position := grid_position + target_direction
		
		var cell : GridCell = GridWorld.get_cell(action_position)
		
		if !cell || (cell.character == null && !cell.blocks_movement()):
			action = MoveAction.new()
			action.type = ActionType.MOVE
		elif cell.character:
			action = AttackAction.new()
			action.weapon = equipment.weapon
			action.type = ActionType.ATTACK
			action.target = cell.character
		elif cell.has_any(Predicates.is_door_entity):
			var door = cell.get_first_match(Predicates.is_door_entity)
			var item_slot := inventory.find_item_slot(ItemRegistry.KEY)
			
			if door.locked && item_slot != null:
				action = UnlockAction.new(item_slot, door)
			elif !door.locked && !door.open:
				action = OpenAction.new()
				action.target = door
		action.position = action_position
		has_moved = true
	elif Input.is_action_just_pressed("move_wait"):
		action.type = ActionType.WAIT
	elif Input.is_action_just_pressed("pick_up") && GridWorld.get_cell(grid_position).has_any(Predicates.is_item_entity):
		action = PickUpAction.new()
	
	if action.type != ActionType.NONE:
		GridWorld.player_input(action)


func play_attack_animation(action: AttackAction):
	var direction = action.target.grid_position - grid_position
	
	direction.x = clamp(direction.x, -1, 1)
	direction.y = clamp(direction.y, -1, 1)
	
	animation_controller.play_attack_animation(Direction.vector2_to_direction(direction))


func on_health_changed(_new_health: int) -> void:
	PlayerEventBus.health_changed.emit(self)


func update_sight():
	sight_controller.update_fov()
	
	GridWorld.set_player_vision(sight_controller.visible_tiles)
	
	queue_redraw()


func _draw() -> void:
	if !debug_draw:
		return
	
	if aiming_ranged_weapon:
		var line_to := PathfindingUtil.get_line_to(grid_position, current_aiming_position)
		
		var scaled_points := []
		
		for pos in line_to:
			scaled_points.append(Vector2(pos - grid_position)*GridWorld.cell_size)
		
		var packed_array := PackedVector2Array(scaled_points)
		
		draw_polyline(scaled_points, Color(1, 1, 1, 0.75), 2.0, true)
