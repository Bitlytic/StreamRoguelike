extends Node2D


var stairs_scene : PackedScene = preload("res://src/entity/staircase.tscn")

var wall_scene : PackedScene = preload("res://src/entity/wall.tscn")

func _ready() -> void:
	
	var tree := BSPTree.new()
	tree.generate()
	
	var output_str:= ""
	
	for i in tree.map.size():
		if i % GridWorld.world_size.x == 0:
			output_str += "\n"
		
		var val = tree.map[i]
		
		if val:
			spawn_wall(i)
			output_str += "#"
		else:
			output_str += "-"
	
	var room : Rect2i = tree.get_first_room()
	
	if room:
		var player_spawn = PlayerSpawn.new()
		player_spawn.global_position = Vector2(room.get_center())*GridWorld.cell_size + GridWorld.cell_size / 2.0
		add_child(player_spawn)
	
	var end_room : Rect2i = tree.get_last_room()
	
	if end_room:
		var staircase := stairs_scene.instantiate()
		staircase.global_position = Vector2(end_room.get_center()) * GridWorld.cell_size + GridWorld.cell_size / 2.0
		staircase.next_level = "res://scenes/level_testing.tscn"
		add_child(staircase)


func spawn_wall(index: int) -> void:
	var wall := wall_scene.instantiate()
	
	wall.grid_position.x = index % GridWorld.world_size.x
	wall.grid_position.y = index / GridWorld.world_size.x
	
	add_child(wall)
	
