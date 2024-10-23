extends Node2D


@onready var heat_map: Node = $HeatMap

var stairs_scene : PackedScene = preload("res://src/entity/staircase.tscn")

var wall_scene : PackedScene = preload("res://src/entity/wall.tscn")

func _ready() -> void:
	
	var tree := BSPTree.new()
	tree.generate()
	
	var output_str:= ""
	
	for i in tree.map.size():
		var e : Entity = tree.map[i]
		
		if e:
			e.grid_position = GridWorld.get_pos_from_index(i)
			if e.get_parent():
				e.owner = null
				e.reparent(self)
			else:
				add_child(e)
	
	var iterations := 0
	
	var first_room : BSPTree.Room = tree.rooms.pick_random()
	
	while first_room.blocks_spawn && iterations < 200:
		first_room = tree.rooms.pick_random()
	
	heat_map.generate_heat_map(first_room.rect.get_center())
	
	for room in tree.rooms:
		room.heat = heat_map.get_room_average(room.rect)
	
	tree.rooms.sort_custom(func(a, b): return a.heat < b.heat)
	
	if first_room:
		var player_spawn = PlayerSpawn.new()
		player_spawn.global_position = Vector2(first_room.rect.get_center())*GridWorld.cell_size + GridWorld.cell_size / 2.0
		add_child(player_spawn)
	
	var end_index := randi_range(1, 3)
	var end_room := tree.rooms[tree.rooms.size() - end_index]
	
	if end_room:
		var staircase := stairs_scene.instantiate()
		staircase.global_position = Vector2(end_room.rect.get_center()) * GridWorld.cell_size + GridWorld.cell_size / 2.0
		staircase.next_level = "res://scenes/level_testing.tscn"
		add_child(staircase)
	
	
	for room : BSPTree.Room in tree.rooms:
		if room.prefab:
			continue
		if randf_range(0, 1) > 2:
			var item : ItemEntity = LootGenerationUtil.generate_loot(room.heat, 0)
			
			item.grid_position = room.rect.get_center()
			get_tree().current_scene.add_child(item)
