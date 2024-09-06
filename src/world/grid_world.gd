class_name GridWorld
extends Node2D


@export var world_size := Vector2i(16, 16)


# Indexed by vector position
var entities : Dictionary = {}


func get_entity(pos: Vector2i) -> Entity:
	return entities.get(pos)


func add_entity(e: Entity):
	# TODO: Stop entities from overlapping
	entities[e.grid_position] = e


func player_input(player: Player, action: EntityAction):
	_perform_action(player, action)
	
	_process_entities()


func _process_entities():
	for e : Entity in entities.values():
		if e is Player:
			continue
		
		var action : EntityAction = e.do_process()
		_perform_action(e, action)


func _perform_action(entity: Entity, action: EntityAction):
	
	# TODO: We should do this
	#action.perform(entity)
	
	match(action.type):
		ActionType.MOVE:
			_move_entity(entity, action.direction)
		ActionType.ATTACK:
			_attack_entity(entity, action)


func _move_entity(entity: Entity, direction : Vector2i):
	entities.erase(entity.grid_position)
	
	var new_pos = entity.grid_position + direction
	
	new_pos.x = clamp(new_pos.x, 0, 16)
	new_pos.y = clamp(new_pos.y, 0, 16)
	
	entity.grid_position = new_pos
	
	entities[entity.grid_position] = entity


func _attack_entity(entity: Entity, action: AttackAction) -> void:
	
	var target_position := entity.grid_position + action.direction
	
	var target_entity = entities.get(target_position)
	
	if target_entity:
		target_entity.process_attack(action.weapon.get_attack())


func can_see(from: Vector2i, to: Vector2i, e: Enemy) -> bool:
	var line_to = PathfindingUtil.get_line_to(from, to)
	
	var p0 : Vector2i
	var p1 : Vector2i
	
	var sum : float
	
	for i in range(line_to.size() - 1):
		p0 = line_to[i]
		p1 = line_to[i + 1]
		sum += (p1 - p0).length()
		# TODO: Add back in vision range
		if sum > e.vision_range:
			return false
	
	line_to.remove_at(0)
	line_to.remove_at(line_to.size()-1)
	
	for point: Vector2i in line_to:
		var cell = get_entity(point)
		#if cell.blocks_movement():
		if cell:
			return false
	
	return true


func update_pathfinding(entity: Entity, a_star_grid: AStarGrid2D) -> void:
	
	for x in a_star_grid.size.x:
		for y in a_star_grid.size.y:
			a_star_grid.set_point_solid(Vector2i(x, y), false)
	
	for e : Entity in entities.values():
		if e == entity:
			continue
		
		if e.blocks_movement || entity.is_passable(e):
			a_star_grid.set_point_solid(e.grid_position)
