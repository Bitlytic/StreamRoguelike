extends Node

var message_scene : PackedScene = preload("res://ui/scenes/world_message.tscn")

var message_queues: Dictionary = {}


var message_time := 0.25
@onready var current_time := message_time


func _process(delta: float) -> void:
	
	if !GridWorld.active:
		return
	
	current_time -= delta
	
	if current_time <= 0:
		show_messages()
		current_time = message_time


func show_messages():
	for pos in message_queues.keys():
		var queue = message_queues.get(pos)
		
		if !queue:
			continue
		
		var message : Message = queue.pop_front()
		
		if !message:
			message_queues.erase(pos)
			continue
		
		var spawned_scene : WorldMessage = message_scene.instantiate()
		spawned_scene.message = message
		get_tree().current_scene.add_child(spawned_scene)
		spawned_scene.global_position = GridWorld.get_global_position(pos)
		
		if queue.size() <= 0:
			message_queues.erase(pos)


func add_message(pos: Vector2i, message: Message) -> void:
	var queue = message_queues.get(pos)
	
	if !queue:
		queue = []
		message_queues[pos] = queue
	
	queue.push_back(message)
