class_name ItemSlot


var item : Item
var count : int

func _init(item: Item = null, count: int = 0):
	self.item = item
	self.count = count


func _to_string() -> String:
	return "Item: " + item.resource_name + " [%d]" % count
