class_name UseItemAction
extends EntityAction


var slot : ItemSlot

func _init(slot: ItemSlot = null):
	self.type = ActionType.USE_ITEM
	self.slot = slot


func perform_action() -> void:
	if slot && slot.item.has_method("use_item"):
		if !target:
			target = owner
		slot.item.use_item(target)
		owner.inventory.remove_item(slot.item, 1)
		
		if owner is Player:
			PlayerEventBus.weight_changed.emit()
