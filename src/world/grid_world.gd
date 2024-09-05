class_name GridWorld
extends Node2D


# Indexed by vector position
var entities : Dictionary = {}


func get_entity(pos: Vector2i) -> Entity:
	return entities.get(pos)


func add_entity(e: Entity):
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


func _attack_entity(entity: Entity, action: EntityAction) -> void:
	
	var target_position := entity.grid_position + action.direction
	
	var target_entity = entities.get(target_position)
	
	if target_entity:
		print(target_entity.health)
		target_entity.process_attack(Attack.new())
	
