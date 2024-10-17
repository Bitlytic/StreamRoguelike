extends Node


signal world_updated()


@export var world_size := Vector2i(40, 21)
@export var cell_size := Vector2(16, 16)

@onready var cycle_timer : Timer = $CycleTimer
@onready var cycle_wait_timer: Timer = $CycleWaitTimer
@onready var reticle: Sprite2D = $Reticle
@onready var tooltip: Node2D = $Tooltip

var aiming_reticle := false

var reticle_position : Vector2i:
	set(val):
		reticle_position = val
		reticle.global_position = val*Vector2i(cell_size) + Vector2i(cell_size / 2.0)


var player : Player:
	get():
		if !player:
			player = get_tree().get_first_node_in_group("player")
		return player


# Indexed by vector position
#var entities : Dictionary = {}
var cells : Dictionary = {}


func _ready():
	clear_cells()
	
	cycle_timer.timeout.connect(on_cycle_timeout)
	cycle_wait_timer.timeout.connect(on_cycle_wait_timeout)


func world_ready():
	world_updated.emit()
	
	reset_cells()
	
	restart_timers()


func clear_cells() -> void:
	cells.clear()
	
	for x in world_size.x:
		for y in world_size.y:
			cells[Vector2i(x, y)] = GridCell.new(Vector2i(x, y))


func get_cell(pos: Vector2i) -> GridCell:
	return cells.get(pos)


func add_entity(e: Entity):
	var cell := get_cell(e.grid_position)
	if !cell:
		cell = GridCell.new(e.grid_position)
		cells[e.grid_position] = cell
	
	cell.add_entity(e)
	if !e.died.is_connected(on_entity_death):
		e.died.connect(on_entity_death)


func remove_entity(entity: Entity, free: bool = true) -> void:
	var cell = get_cell(entity.grid_position)
	cell.remove_entity(entity)
	entity.queue_free()


func move_entity(entity: Entity, old_pos: Vector2i):
	var new_pos = clamp_to_bounds(entity.grid_position)
	
	if new_pos != entity.grid_position:
		entity.grid_position = old_pos
		return
	
	get_cell(old_pos).remove_entity(entity)
	
	get_cell(entity.grid_position).add_entity(entity)


func player_input(action: EntityAction):
	if action.type == ActionType.NONE:
		return
	
	player.reset_modifiers()
	player.tick_effects()
	
	if player.stunned:
		action = EntityAction.new(ActionType.WAIT)
	
	if action is AttackAction && !action.weapon:
		action.weapon = player.equipment.weapon
	
	action.owner = player
	
	_perform_action(action)
	
	_process_entities()


func _process_entities():
	for cell : GridCell in cells.values():
		if cell.character && !cell.character.processed_this_frame:
			var action : EntityAction = cell.character.do_process()
			if cell.character:
				action.owner = cell.character
				_perform_action(action)
		
		for e in cell.get_entities():
			if e is Player:
				continue
			
			if e.processed_this_frame:
				continue
			
			var action : EntityAction = e.do_process()
			action.owner = e
			_perform_action(action)
	
	reset_cells()
	
	restart_timers()
	
	player.update_sight()
	
	GridWorld.world_updated.emit()


func reset_cells() -> void:
	for cell: GridCell in cells.values():
		if cell.character:
			cell.character.processed_this_frame = false
		for e in cell.get_entities():
			e.processed_this_frame = false
		cell.reset_display()


func restart_timers() -> void:
	cycle_wait_timer.start()
	cycle_timer.stop()
	MessageManager.current_time = 0.0


func _perform_action(action: EntityAction):
	action.perform_action()
	
	action.owner.processed_this_frame = true


func can_see(from: Vector2i, to: Vector2i, e: Enemy) -> bool:
	var line_to = PathfindingUtil.get_line_to(from, to)
	
	var p0 : Vector2i
	var p1 : Vector2i
	
	var sum : float
	
	for i in range(line_to.size() - 1):
		p0 = line_to[i]
		p1 = line_to[i + 1]
		sum += (p1 - p0).length()
		if sum > e.vision_range:
			return false
	
	line_to.remove_at(0)
	line_to.remove_at(line_to.size()-1)
	
	for point: Vector2i in line_to:
		var cell = get_cell(point)
		if cell && cell.blocks_vision():
			return false
	
	return true


func update_pathfinding(entity: Entity, a_star_grid: AStarGrid2D, only_visible: bool = false) -> void:
	a_star_grid.fill_solid_region(Rect2i(0, 0, world_size.x, world_size.y), false)
	
	for cell_pos : Vector2i in cells.keys():
		var cell : GridCell = cells.get(cell_pos)
		if only_visible && !cell.discovered:
			a_star_grid.set_point_solid(cell_pos)
			continue
		
		if cell.character == entity || cell.character is Player:
			continue
		
		if cell && cell.blocks_movement():
			if cell.has_any(Predicates.is_door_entity):
				var door : DoorEntity = cell.get_first_match(Predicates.is_door_entity)
				a_star_grid.set_point_solid(cell_pos, door.locked)
			else:
				a_star_grid.set_point_solid(cell_pos)


func on_entity_death(entity: Entity) -> void:
	if entity is Player:
		#TODO: Game over stuff
		print("The player fuckin died")
	
	remove_entity(entity)


func on_cycle_wait_timeout() -> void:
	cycle_timer.start()


func on_cycle_timeout() -> void:
	for cell : GridCell in cells.values():
		if aiming_reticle && cell.grid_position == reticle_position:
			if reticle.visible:
				cell.set_display(true)
				cell.cycle_display()
				reticle.hide()
			else:
				cell.set_display(false)
				reticle.show()
		else:
			cell.cycle_display()


func is_in_bounds(pos: Vector2i) -> bool:
	return (pos.x >= 0 && pos.x < world_size.x) && (pos.y >= 0 && pos.y < world_size.y)


func clamp_to_bounds(pos: Vector2i) -> Vector2i:
	pos.x = clamp(pos.x, 0, world_size.x - 1)
	pos.y = clamp(pos.y, 0, world_size.y - 1)
	
	return pos

func set_player_vision(tiles: Array[Vector2]) -> void:
	
	for cell : GridCell in cells.values():
		
		if tiles.has(Vector2(cell.grid_position)):
			cell.set_player_visible(true)
		else:
			cell.set_player_visible(false)


func show_reticle() -> void:
	reticle.show()
	aiming_reticle = true
	get_cell(reticle_position).set_display(true)

func hide_reticle() -> void:
	reticle.hide()
	aiming_reticle = false
	get_cell(reticle_position).set_display(true)


func update_reticle_position(new_pos: Vector2i) -> void:
	var old_cell :=  get_cell(reticle_position)
	old_cell.current_display_index = 0
	old_cell.set_display(true)
	
	reticle.show()
	reticle_position = new_pos
	
	get_cell(reticle_position).set_display(false)
	
	restart_timers()


func hide_tooltip() -> void:
	tooltip.visible = false


func set_tooltip_name(text: String) -> void:
	tooltip.entity_name = text
	tooltip.visible = true


func set_tooltip_description(text: String) -> void:
	tooltip.entity_description = text
	tooltip.visible = true


func set_tooltip_position(pos: Vector2i) -> void:
	tooltip.visible = false
	tooltip.grid_position = pos
	
	var cell : GridCell = get_cell(tooltip.grid_position)
	
	if !cell.in_vision:
		return
	
	var tooltip_name := ""
	var tooltip_description := ""
	
	if cell.character:
		tooltip_name = cell.character.get_entity_name()
		tooltip_description = cell.character.get_description()
	
	if !tooltip_name && cell.get_entities().size() > 0:
		var entity := cell.get_entities()[0]
		if entity:
			tooltip_name = entity.get_entity_name()
			tooltip_description = entity.get_description()
	
	if tooltip_name:
		set_tooltip_name(tooltip_name)
		set_tooltip_description(tooltip_description)
