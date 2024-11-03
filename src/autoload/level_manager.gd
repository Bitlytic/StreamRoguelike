extends Node


var current_level := 0

var player_turns_on_floor := 0
var total_turns := 0


func _ready() -> void:
	GridWorld.world_updated.connect(on_world_updated)


func switch_to_level(scene: PackedScene) -> void:
	
	ActionLog.add_action(FloorLogItem.new(player_turns_on_floor, current_level))
	
	current_level += 1
	
	# Pluck the player out of Scene
	var player := get_tree().get_first_node_in_group("player")
	player.reparent(get_tree().root)
	
	# Switch to new scene
	get_tree().change_scene_to_packed(scene)
	
	# Reset GridWorld cells
	GridWorld.clear_cells()
	
	
	# Place player back in
	await get_tree().process_frame
	add_player(player)
	
	player_turns_on_floor = 0
	
	PlayerEventBus.floor_changed.emit()


func add_player(player: Player) -> void:
	var player_spawn = get_tree().get_first_node_in_group("player_spawn")
	
	if player_spawn:
		player.global_position = player_spawn.global_position
		player_spawn.queue_free()
	
	player.reparent(get_tree().current_scene)
	player.register_self()


func on_world_updated():
	player_turns_on_floor += 1
	total_turns += 1
