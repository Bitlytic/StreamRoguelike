class_name EntityDialog
extends ListDialog


signal entity_selected(result: Entity)


func _physics_process(delta: float) -> void:
	if !visible:
		return
	
	poll_input()


func display_entities(cell: GridCell):
	clear_options()
	
	if cell.character:
		create_button(cell.character.get_entity_name(), cell.character)
	
	for e in cell.get_entities():
		create_button(e.get_entity_name(), e)
	
	if action_buttons.size() <= 0:
		entity_selected.emit(null)
		return
	
	connect_options(on_entity_selected)
	
	_change_focus(0)
	
	show()


func on_entity_selected(result: Object):
	if result is Entity:
		entity_selected.emit(result)
		hide()
	
