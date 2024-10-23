class_name ItemDescriptionDialog
extends ListDialog


signal description_closed()


@onready var description_label: Label = $Panel/ButtonContainer/DescriptionLabel


func _physics_process(delta: float) -> void:
	if !visible:
		return
	
	poll_input()


func display_actions(item: Item):
	list_name = str(item)
	
	description_label.text = item.get_description()
	
	populate_options()
	
	connect_options(on_action_selected)
	
	_change_focus(0)
	
	show()


func on_action_selected(action: Object):
	description_closed.emit()


func populate_options():
	clear_options()
	
	create_button("OK", null)
