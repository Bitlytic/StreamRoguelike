class_name AmbientTile
extends Node2D


@export var discovered_color := Color("#434343")
@export var vision_color := Color("#FFFFFF")

var discovered := false
var in_vision := false :
	set(val):
		if val:
			discovered = true
			modulate = vision_color
		else:
			if discovered:
				modulate = discovered_color
			else:
				modulate = Color(0, 0, 0, 0)


var grid_position : Vector2i
var cell : GridCell


func _ready() -> void:
	GridWorld.world_updated.connect(on_world_updated)
	
	grid_position = Vector2i(global_position.floor() / GridWorld.cell_size)
	global_position += GridWorld.cell_size / 2.0
	cell = GridWorld.get_cell(grid_position)
	cell.ambient_tile = self
	
	on_world_updated()


func on_world_updated():
	
	if cell.get_entity_count():
		if cell.character && !cell.character.in_vision:
			show()
			return
		hide()
	else:
		show()
