class_name UnequipAction
extends EntityAction


var item: Item


func _init(item: Item):
	self.item = item
	self.type = ActionType.EQUIP


func perform_action() -> void:
	if owner is Player:
		if item is BasicWeapon:
			_swap_item("weapon")
		elif item is RangedWeapon:
			_swap_item("ranged_weapon")
		
		if item is Armor:
			match item.slot:
				Armor.ArmorSlot.HELMET:
					_swap_item("helmet")
				Armor.ArmorSlot.CHESTPLATE:
					_swap_item("chestplate")
				Armor.ArmorSlot.BOOTS:
					_swap_item("boots")
		
		PlayerEventBus.weight_changed.emit(owner)


func _swap_item(property_name: String) -> void:
	if owner.equipment.get(property_name):
		owner.inventory.add_item(owner.equipment.get(property_name))
	owner.equipment.set(property_name, null)
