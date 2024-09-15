extends Node


signal world_updated()


@export var world_size := Vector2i(40, 21)
@export var cell_size := Vector2(16, 16)

@onready var cycle_timer : Timer = $CycleTimer
@onready var cycle_wait_timer: Timer = $CycleWaitTimer


var player : Player:
	get():
		if !player:
			player = get_tree().get_first_node_in_group("player")
		return player


# Indexed by vector position
#var entities : Dictionary = {}
var cells : Dictionary = {}


func _ready():
	for x in world_size.x:
		for y in world_size.y:
			cells[Vector2i(x, y)] = GridCell.new()
	
	cycle_timer.timeout.connect(on_cycle_timeout)
	cycle_wait_timer.timeout.connect(on_cycle_wait_timeout)


func get_cell(pos: Vector2i) -> GridCell:
	return cells.get(pos)


func add_entity(e: Entity):
	var cell := get_cell(e.grid_position)
	if !cell:
		cell = GridCell.new()
		cells[e.grid_position] = cell
	
	cell.add_entity(e)
	e.died.connect(on_entity_death)


func remove_entity(entity: Entity) -> void:
	var cell = get_cell(entity.grid_position)
	cell.remove_entity(entity)
	entity.queue_free()


func move_entity(entity: Entity, old_pos: Vector2i):
	var new_pos = entity.grid_position.clamp(Vector2i(0, 0), world_size - Vector2i(1, 1))
	
	if new_pos != entity.grid_position:
		entity.grid_position = old_pos
		return
	
	get_cell(old_pos).remove_entity(entity)
	
	get_cell(entity.grid_position).add_entity(entity)


func player_input(action: EntityAction):
	if action.type == ActionType.NONE:
		return
	
	action.owner = player
	
	# TODO: this sucks, don't do this eventually
	if action is AttackAction:
		action.weapon = player.weapon
	
	_perform_action(action)
	
	_process_entities()


func _process_entities():
	for cell : GridCell in cells.values():
		if cell.character && !cell.character.processed_this_frame:
			var action : EntityAction = cell.character.do_process()
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
	
	for cell : GridCell in cells.values():
		if cell.character:
			cell.character.processed_this_frame = false
		for e in cell.get_entities():
			e.processed_this_frame = false
		cell.reset_display()
	
	cycle_wait_timer.start()
	cycle_timer.stop()
	
	GridWorld.world_updated.emit()


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


func update_pathfinding(entity: Entity, a_star_grid: AStarGrid2D) -> void:
	a_star_grid.fill_solid_region(Rect2i(0, 0, world_size.x, world_size.y), false)
	
	for cell_pos : Vector2i in cells.keys():
		var cell : GridCell = cells.get(cell_pos)
		if cell.character == entity || cell.character is Player:
			continue
		
		if cell && cell.blocks_movement():
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
		cell.cycle_display()
