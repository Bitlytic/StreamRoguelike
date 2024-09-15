extends Node2D


var cell : GridCell


func _ready() -> void:
	GridWorld.world_updated.connect(on_world_updated)
	
	var grid_position = Vector2i(global_position.floor() / GridWorld.cell_size)
	cell = GridWorld.get_cell(grid_position)
	
	on_world_updated()


func on_world_updated():
	
	if cell.blocks_movement():
		hide()
	else:
		show()
