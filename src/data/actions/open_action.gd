class_name OpenAction
extends EntityAction


func _init(target: DoorEntity = null):
	self.type = ActionType.OPEN
	self.target = target


func perform_action() -> void:
	if target.has_method("toggle_open"):
		target.toggle_open()
