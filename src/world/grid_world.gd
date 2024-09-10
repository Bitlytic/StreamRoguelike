class_name GridWorld
extends Node2D


@export var world_size := Vector2i(40, 21)
@export var cell_size := Vector2(16, 16)

@onready var cycle_timer : Timer = $CycleTimer
@onready var cycle_wait_timer: Timer = $CycleWaitTimer


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
	# TODO: Stop entities from overlapping
	var cell := get_cell(e.grid_position)
	if !cell:
		cell = GridCell.new()
		cells[e.grid_position] = cell
	
	cell.add_entity(e)
	e.died.connect(on_entity_death)


func player_input(player: Player, action: EntityAction):
	_perform_action(player, action)
	
	_process_entities()


func _process_entities():
	for cell : GridCell in cells.values():
		if cell.character && !cell.character.processed_this_frame:
			var action : EntityAction = cell.character.do_process()
			_perform_action(cell.character, action)
		
		for e in cell.get_entities():
			if e is Player:
				continue
			
			if e.processed_this_frame:
				continue
			
			var action : EntityAction = e.do_process()
			_perform_action(e, action)
	
	for cell : GridCell in cells.values():
		if cell.character:
			cell.character.processed_this_frame = false
		for e in cell.get_entities():
			e.processed_this_frame = false
		cell.reset_display()
	
	cycle_wait_timer.start()
	cycle_timer.stop()


func _perform_action(entity: Entity, action: EntityAction):
	
	# TODO: We should do this
	#action.perform(entity)
	
	match(action.type):
		ActionType.MOVE:
			_move_entity(entity, action)
		ActionType.ATTACK:
			_attack_entity(entity, action)
		ActionType.PICK_UP:
			_pick_up_entity(entity, action)
	
	entity.processed_this_frame = true


func _move_entity(entity: Entity, action : EntityAction):
	get_cell(entity.grid_position).remove_entity(entity)
	
	var new_pos = action.position
	
	new_pos.x = clamp(new_pos.x, 0, world_size.x)
	new_pos.y = clamp(new_pos.y, 0, world_size.y)
	
	entity.grid_position = new_pos
	
	get_cell(entity.grid_position).add_entity(entity)


func _attack_entity(entity: Entity, action: AttackAction) -> void:
	
	var target_entity = get_cell(action.position).character
	
	if target_entity:
		target_entity.process_attack(action.weapon.get_attack())


func _pick_up_entity(entity: Entity, action: EntityAction):
	var target_entity : Entity = null
	
	for e in get_cell(action.position).get_entities():
		if e is ItemEntity:
			target_entity = e
	
	if target_entity && target_entity is ItemEntity:
		entity.inventory.add_item(target_entity.item, target_entity.count)
		_remove_entity(target_entity)


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
	
	#TODO: Also account for multiple entities if we have that
	_remove_entity(entity)


func _remove_entity(entity: Entity) -> void:
	var cell = get_cell(entity.grid_position)
	cell.remove_entity(entity)
	entity.queue_free()


func on_cycle_wait_timeout() -> void:
	cycle_timer.start()

func on_cycle_timeout() -> void:
	for cell : GridCell in cells.values():
		cell.cycle_display()
