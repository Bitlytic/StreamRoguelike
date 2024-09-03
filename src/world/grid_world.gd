class_name GridWorld
extends Node2D


# Indexed by vector position
var entities : Dictionary = {}


func get_entity(pos: Vector2i):
	return entities.get(pos)


func add_entity(e: Entity):
	e.grid_position = Vector2i(5, 5)
	entities[e.grid_position] = e


func player_input(player: Player, direction: Vector2):
	print(direction)
	var dir := Vector2i(direction)
	print(dir)
	entities[player.grid_position] = null
	
	var new_pos = player.grid_position + dir
	
	new_pos.x = clamp(new_pos.x, 0, 16)
	new_pos.y = clamp(new_pos.y, 0, 16)
	
	player.grid_position = new_pos
	
	entities[player.grid_position] = player
	

func process_entities():
	for e in entities.values():
		if e is Player:
			continue
		e.process()
