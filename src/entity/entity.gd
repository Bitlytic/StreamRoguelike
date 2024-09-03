class_name Entity
extends Node2D

@onready var grid_world : GridWorld = get_tree().get_first_node_in_group("world")

@export var starting_position := Vector2i(0, 0)

var cell_size := Vector2(16, 16)

var grid_position : Vector2i : 
	set(val):
		grid_position = val
		_update_render_position()


func _ready():
	grid_position = starting_position
	grid_world.add_entity(self)


func do_process() -> EntityAction:
	var action = EntityAction.new(ActionType.MOVE, Vector2(0, 1))
	return action


func _update_render_position() -> void:
	global_position = Vector2(grid_position)*cell_size
