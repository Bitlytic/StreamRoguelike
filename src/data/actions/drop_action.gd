class_name DropAction
extends EntityAction


var item_entity_scene: PackedScene = preload("res://src/entity/item/item_entity.tscn")


var slot: ItemSlot


func _init(slot: ItemSlot = null):
	self.type = ActionType.DROP_ITEM
	self.slot = slot


func perform_action():
	var spawned_entity : ItemEntity = item_entity_scene.instantiate()
	
	spawned_entity.count = slot.count
	spawned_entity.item = slot.item
	
	spawned_entity.grid_position = owner.grid_position
	
	owner.get_tree().current_scene.add_child(spawned_entity)
	
	owner.inventory.remove_item(slot.item, slot.count)
	
	if owner is Player:
		PlayerEventBus.weight_changed.emit(owner)
	
	if spawned_entity.item is Key:
		PlayerEventBus.keys_changed.emit(owner)
