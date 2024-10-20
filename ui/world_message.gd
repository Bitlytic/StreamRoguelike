class_name WorldMessage
extends Control


@onready var message_label: Label = $Control/MessageText

var message: Message


func _ready():
	message_label.text = message.text
	message_label.add_theme_color_override("font_color", message.color)
	message_label.position.x = -message_label.size.x / 2.0
	
	global_position += Vector2(randf_range(-4, 4), randf_range(-4, 4))
	var s = randf_range(0.9, 1.1)
	scale.x = s
	scale.y = s
