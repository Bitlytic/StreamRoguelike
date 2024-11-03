@tool
class_name PrefabRoom
extends Node2D

## Inner area not including walls
@export var room_size: Vector2i

@export var blocks_spawn : bool

@export var reload : bool:
	set(val):
		generate_walls()

@export var justify : bool:
	set(val):
		justify_entities()

@onready var wall_container := $Walls

var wall_scene : PackedScene


func generate_walls() -> void:
	wall_scene = load("res://src/entity/wall.tscn")
	
	for child in wall_container.get_children(true):
		child.free()
	
	for y in range(room_size.y + 2):
		for x in range(room_size.x + 2):
			if y == 0 || y > room_size.y:
				spawn_wall(x, y)
			else:
				if x == 0 || x > room_size.x:
					spawn_wall(x, y)


func spawn_wall(x: int, y: int) -> void:
	var spawned_wall := wall_scene.instantiate()
	
	spawned_wall.global_position = Vector2(x, y) * Vector2(16, 16) - Vector2(16, 16)
	
	wall_container.add_child(spawned_wall)
	spawned_wall.owner = self


func justify_entities() -> void:
	for child in get_children():
		if child is Node2D:
			var grid_position = floor(child.global_position) / Vector2(16, 16)
			child.global_position = floor(grid_position) * Vector2(16, 16) + Vector2(8, 8)
