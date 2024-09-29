class_name UnlockAction
extends EntityAction

var slot : ItemSlot

func _init(slot: ItemSlot = null, target: Entity = null):
	self.type = ActionType.UNLOCK
	self.slot = slot
	self.target = target


func perform_action() -> void:
	var key_slot = slot
	
	if !slot:
		slot = owner.inventory.find_item_slot(ItemRegistry.KEY)
	
	if slot && slot.item is Key:
		if target && target.has_method("unlock"):
			target.unlock()
			owner.inventory.remove_item(slot.item, 1)
