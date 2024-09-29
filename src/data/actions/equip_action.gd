class_name EquipAction
extends EntityAction


var slot : ItemSlot


func _init(slot: ItemSlot):
	self.slot = slot
	self.type = ActionType.EQUIP


func perform_action() -> void:
	if owner is Player:
		var item = slot.item
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


func _swap_item(property_name: String) -> void:
	if owner.equipment.get(property_name):
		owner.inventory.add_item(owner.equipment.get(property_name))
	owner.equipment.set(property_name, slot.item)
	owner.inventory.remove_item(owner.equipment.get(property_name))
