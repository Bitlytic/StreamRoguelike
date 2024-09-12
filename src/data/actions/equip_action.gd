class_name EquipAction
extends EntityAction


var slot : ItemSlot


func _init(slot: ItemSlot):
	self.slot = slot


func perform_action() -> void:
	if owner is Player:
		owner.inventory.add_item(owner.weapon)
		
		owner.weapon = slot.item
		
		owner.inventory.remove_item(owner.weapon)
