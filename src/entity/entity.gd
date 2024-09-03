class_name Entity
extends Node2D


var cell_size := Vector2(16, 16)

var grid_position : Vector2i : 
	set(val):
		grid_position = val
		_update_render_position()


func do_process() -> int:
	return 0


func _update_render_position() -> void:
	global_position = Vector2(grid_position)*cell_size
