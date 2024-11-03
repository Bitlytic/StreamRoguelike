class_name ItemLootAction
extends ActionLogItem


var item : Item


func _init(item: Item):
	self.item = item


func _to_string():
	return "You looted %s" % [item]
