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
		
		GridWorld.remove_entity(target)
