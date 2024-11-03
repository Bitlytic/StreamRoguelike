extends Control


@export var log_container : Control


var action_scene : PackedScene = preload("res://ui/scenes/action_log_label.tscn")

func _ready():
	
	ActionManager.show_death()
	
	for child in log_container.get_children():
		child.queue_free()
	
	for action in ActionLog.actions:
		var spawned = action_scene.instantiate()
		spawned.text = str(action)
		log_container.add_child(spawned)
