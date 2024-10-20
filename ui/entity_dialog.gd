class_name EntityDialog
extends ListDialog


signal entity_selected(result: Entity)


func _physics_process(delta: float) -> void:
	if !visible:
		return
	
	poll_input()


func display_entities(cell: GridCell):
	clear_options()
	
	var index := 1
	
	if cell.character && cell.character is not Player:
		create_button(cell.character.get_entity_name(), cell.character, str(index))
		index += 1
	
	for e in cell.get_entities():
		create_button(e.get_entity_name(), e, str(index))
		index += 1
	
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
	
