class_name ItemActionDialog
extends ListDialog


signal item_action_selected(action: EntityAction)


var item_slot : ItemSlot


func _physics_process(delta: float) -> void:
	if !visible:
		return
	
	poll_input()


func display_actions(slot: ItemSlot):
	item_slot = slot
	
	var action_types : Array[int] = [ActionType.DROP_ITEM]
	
	if slot.item is BasicWeapon || slot.item is Armor || slot.item is RangedWeapon:
		action_types.append(ActionType.EQUIP)
	
	if slot.item.has_method("use_item"):
		action_types.append(ActionType.USE_ITEM)
	
	populate_options(action_types)
	
	if action_buttons.size() <= 0:
		item_action_selected.emit(null)
		return
	
	connect_options(on_action_selected)
	
	_change_focus(0)
	
	show()


func on_action_selected(action: Object):
	if action is EntityAction:
		item_action_selected.emit(action)


func populate_options(actions: Array[int]):
	clear_options()
	
	for action in actions:
		match(action):
			ActionType.DROP_ITEM:
				create_button("Drop", DropAction.new(item_slot), "D")
			ActionType.EQUIP:
				create_button("Equip", EquipAction.new(item_slot), "E")
			ActionType.USE_ITEM:
				create_button("Use", UseItemAction.new(item_slot), "U")
