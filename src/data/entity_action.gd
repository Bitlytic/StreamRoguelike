class_name EntityAction
extends Resource

@export_enum("NONE", "WAIT", "MOVE", "ATTACK", "PICK_UP", "DROP_ITEM") var type : int = ActionType.NONE
var position := Vector2i(0, 0)


func _init(type: int = ActionType.NONE, position := Vector2i(0, 0)):
	self.type = type
	self.position = position


func _to_string() -> String:
	return "Type: " + str(type) + ", position: " + str(position)
