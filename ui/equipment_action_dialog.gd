class_name EquipmentActionDialog
extends ListDialog


signal equipment_action_selected(action: EntityAction)


var item : Item


func _physics_process(delta: float) -> void:
	if !visible:
		return
	
	poll_input()


func display_actions(item: Item):
	label.text = item.item_name
	self.item = item
	
	var action_types : Array[int] = [ActionType.UNEQUIP]
	
	populate_options(action_types)
	
	if action_buttons.size() <= 0:
		equipment_action_selected.emit(null)
		return
	
	connect_options(on_action_selected)
	
	_change_focus(0)
	
	show()


func on_action_selected(action: Object):
	if action is EntityAction:
		equipment_action_selected.emit(action)


func populate_options(actions: Array[int]):
	clear_options()
	
	for action in actions:
		match(action):
			ActionType.UNEQUIP:
				create_button("Unequip", UnequipAction.new(item), "E")
	
	create_button("Inspect", InspectAction.new(item), "I")
