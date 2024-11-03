class_name FloorLogItem
extends ActionLogItem


var turns : int
var floor : int


func _init(turns: int, floor: int):
	self.turns = turns
	self.floor = floor + 1


func _to_string() -> String:
	return "It took you %d turns to complete floor %d" % [turns, floor]
