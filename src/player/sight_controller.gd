class_name SightController
extends Node

@export var degree_step := 5.0

@onready var player : Player = get_owner()


func update_sight() -> Array[Vector2i]:
	
	var positions_to_check : Array[Vector2i] = []
	
	var current_offset : Vector2 = Vector2i(0, -player.vision_range)
	var total_steps := 360.0 / degree_step
	for i in total_steps:
		current_offset = current_offset.rotated(deg_to_rad(degree_step))
		
		var grid_pos := Vector2i(current_offset)
		
		if !positions_to_check.has(grid_pos):
			positions_to_check.append(grid_pos)
	
	var valid_positions : Array[Vector2i] = []
	
	var target_position : Vector2i
	
	for pos in positions_to_check:
		target_position = player.grid_position + pos
		target_position.x = clamp(target_position.x, 0, GridWorld.world_size.x - 1)
		target_position.y = clamp(target_position.y, 0, GridWorld.world_size.y - 1)
		
		var line_to := PathfindingUtil.get_line_to(player.grid_position, target_position)
		
		for point in line_to:
			if GridWorld.get_cell(point).blocks_vision():
				break
			if !valid_positions.has(point):
				valid_positions.append(point)
	
	return valid_positions
