class_name EntityAction


var type : int = ActionType.NONE
var direction := Vector2i(0, 1)


func _init(type: int = ActionType.NONE, direction := Vector2i(0, 0)):
	self.type = type
	self.direction = direction


func _to_string() -> String:
	return "Type: " + str(type) + ", direction: " + str(direction)
