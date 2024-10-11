class_name PlayerSpawn
extends Node2D


@export var player: PackedScene = preload("res://src/player/player.tscn")


func _ready():
	var existing_player : Player = get_tree().get_first_node_in_group("player")
	
	if !existing_player:
		existing_player = player.instantiate()
		existing_player.global_position = global_position
		get_tree().current_scene.add_child.call_deferred(existing_player)
		queue_free()
	
	add_to_group("player_spawn")
