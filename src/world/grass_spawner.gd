extends Node

@export var noise: FastNoiseLite
@export var sample_minimum := 0.5

var ambient_tile_scene := preload("res://src/world/ambient_tile.tscn") 


func _ready() -> void:
	
	noise.seed = randi()
	
	for x in GridWorld.world_size.x:
		for y in GridWorld.world_size.y:
			var sample := noise.get_noise_2d(x, y)
			
			spawn_ambient(x, y, sample)


func spawn_ambient(x: float, y: float, sample: float) -> void:
	var spawned_scene := ambient_tile_scene.instantiate()
	
	spawned_scene.global_position.x = x
	spawned_scene.global_position.y = y
	
	spawned_scene.global_position *= GridWorld.cell_size
	
	if sample > sample_minimum:
		spawned_scene.has_grass = true
	
	get_tree().current_scene.add_child.call_deferred(spawned_scene)
