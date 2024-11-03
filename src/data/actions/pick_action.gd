class_name PickUpAction
extends EntityAction


func _init():
	self.type = ActionType.PICK_UP


func perform_action() -> void:
	
	if target is ItemEntity:
		var owner_weight := owner.get_weight()
		if owner_weight + target.item.weight > owner.get_max_weight():
			return
		owner.inventory.add_item(target.item, target.count)
		
		if owner is Player:
			PlayerEventBus.weight_changed.emit(owner)
		
		if target.item is Key:
			PlayerEventBus.keys_changed.emit(owner)
		elif !target.item.has_looted:
			target.item.has_looted = true
			ActionLog.add_action(ItemLootAction.new(target.item))
		
		GridWorld.remove_entity(target)
