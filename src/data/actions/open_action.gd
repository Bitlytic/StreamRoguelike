class_name OpenAction
extends EntityAction


func _init():
	self.type = ActionType.OPEN


func perform_action(target: Entity) -> void:
	if target.has_method("toggle_open"):
		target.toggle_open()
