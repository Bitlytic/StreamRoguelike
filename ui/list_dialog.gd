class_name ListDialog
extends Control


var action_button_scene := preload("res://ui/action_button.tscn")

@onready var button_container : VBoxContainer = $Panel/ButtonContainer
var action_buttons : Array[ActionButton]

var current_focused_index := 0

func clear_options():
	for child in button_container.get_children():
		if child is ActionButton:
			child.queue_free()
	
	action_buttons.clear()

func connect_options(f: Callable):
	for button in action_buttons:
		button.option_selected.connect(f)


func poll_input():
	if Input.is_action_just_pressed("move_south"):
		_change_focus(1)
	elif Input.is_action_just_pressed("move_north"):
		_change_focus(-1)


func _change_focus(direction: int):
	
	for i in action_buttons.size():
		var button : Button = action_buttons[i]
		if button.has_focus():
			current_focused_index = i
			break
	
	current_focused_index += direction
	current_focused_index %= action_buttons.size()
	action_buttons[current_focused_index].grab_focus()


func create_button(text: String, result: Object):
	var spawned_button : ActionButton = action_button_scene.instantiate()
	
	spawned_button.result = result
	spawned_button.option_name = text
	
	action_buttons.append(spawned_button)
	
	button_container.add_child(spawned_button)
