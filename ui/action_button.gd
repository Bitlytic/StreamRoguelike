class_name ActionButton
extends Button


signal action_selected(action: EntityAction)


@export var action_name := "Attack"

@export var action : EntityAction


@onready var selection_caret: Label = $HBoxContainer/SelectionCaret
@onready var action_label: Label = $HBoxContainer/ActionLabel


func _ready():
	selection_caret.hide()
	focus_entered.connect(on_focus_entered)
	focus_exited.connect(on_focus_exited)
	mouse_entered.connect(on_mouse_entered)
	pressed.connect(on_button_pressed)
	
	action_label.text = action_name


func on_button_pressed():
	action_selected.emit(action)


func on_focus_entered():
	selection_caret.show()


func on_focus_exited():
	selection_caret.hide()


func on_mouse_entered():
	grab_focus()
