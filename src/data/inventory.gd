class_name Inventory


var _items : Dictionary = {}


func _init():
	pass


func add_item(item: Item, count: int = 1) -> void:
	
	var existing_slot = find_item_slot(item)
	if existing_slot:
		existing_slot.count += count
		return
	
	var slot = ItemSlot.new(item, count)
	_items[item] = slot


func remove_item(item: Item, count: int = 1):
	
	var existing_slot = find_item_slot(item)
	
	if existing_slot:
		existing_slot.count -= count
		if existing_slot.count <= 0:
			_items.erase(item)
	else:
		push_error("We don't have an item slot for that! ", item)


func get_items() -> Array:
	return _items.values()


func find_item_slot(item: Item) -> ItemSlot:
	var slot : ItemSlot = _items.get(item)
	
	return slot


func get_weight() -> float:
	var total := 0.0
	for slot : ItemSlot in _items.values():
		total += slot.item.weight * slot.count
	
	return total
