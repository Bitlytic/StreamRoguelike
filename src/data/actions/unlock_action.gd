class_name UnlockAction
extends EntityAction

var slot : ItemSlot

func _init(target: Entity = null, slot: ItemSlot = null):
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
			if owner is Player:
				PlayerEventBus.weight_changed.emit(owner)
				PlayerEventBus.keys_changed.emit(owner)
