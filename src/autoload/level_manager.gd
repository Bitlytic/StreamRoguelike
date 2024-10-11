extends Node


func switch_to_level(scene: PackedScene) -> void:
	
	# Pluck the player out of Scene
	var player := get_tree().get_first_node_in_group("player")
	player.reparent(get_tree().root)
	
	# Switch to new scene
	get_tree().change_scene_to_packed(scene)
	
	# Reset GridWorld cells
	GridWorld.clear_cells()
	
	
	# Place player back in
	await get_tree().tree_changed
	add_player(player)


func add_player(player: Player) -> void:
	var player_spawn = get_tree().get_first_node_in_group("player_spawn")
	
	if player_spawn:
		player.global_position = player_spawn.global_position
		player_spawn.queue_free()
	
	player.reparent(get_tree().current_scene)
	player.register_self()
