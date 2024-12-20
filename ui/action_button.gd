class_name ActionButton
extends Button


signal option_selected(result: Object)


@export var option_name := "Attack"


@onready var selection_caret: Label = $HBoxContainer/SelectionCaret
@onready var selection_caret2: Label = $HBoxContainer/SelectionCaret2
@onready var action_label: RichTextLabel = $HBoxContainer/ActionLabel
@onready var key_code_label: Label = $HBoxContainer/KeyCodeLabel


var key_code : String = ""

var result : Object


func _ready():
	selection_caret.hide()
	selection_caret2.hide()
	focus_entered.connect(on_focus_entered)
	focus_exited.connect(on_focus_exited)
	mouse_entered.connect(on_mouse_entered)
	pressed.connect(on_button_pressed)
	
	if key_code:
		key_code_label.text = "[%s]" % key_code
	
	action_label.text = option_name


func _physics_process(_delta: float) -> void:
	
	if key_code:
		var input_key := OS.find_keycode_from_string(key_code)
		
		if input_key && Input.is_key_pressed(input_key):
			key_code = ""
			on_button_pressed()


func on_button_pressed():
	option_selected.emit(result)


func on_focus_entered():
	selection_caret.show()
	selection_caret2.show()


func on_focus_exited():
	selection_caret.hide()
	selection_caret2.hide()


func on_mouse_entered():
	grab_focus()
