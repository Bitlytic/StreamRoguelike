class_name InventoryDialog
extends ListDialog


signal item_selected(result: ItemSlot)


func _physics_process(delta: float) -> void:
	if !visible:
		return
	poll_input()


func display_items(inventory: Inventory) -> void:
	clear_options()
	
	
	for stack: ItemSlot in inventory.get_items():
		var button_text := stack.item.item_name
		
		if stack.count > 1:
			button_text += " - " + str(stack.count)
		
		create_button(button_text, stack)
	
	if action_buttons.size() <= 0:
		item_selected.emit(null)
		return
	
	connect_options(on_item_selected)
	
	_change_focus(0)
	
	show()


func on_item_selected(result: Object) -> void:
	
	if result is ItemSlot:
		item_selected.emit(result)
		hide()
