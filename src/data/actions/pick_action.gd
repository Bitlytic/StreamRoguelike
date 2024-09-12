class_name PickUpAction
extends EntityAction


func _init():
	self.type = ActionType.PICK_UP


func perform_action() -> void:
	if target is ItemEntity:
		owner.inventory.add_item(target.item, target.count)
		
		GridWorld.remove_entity(target)
