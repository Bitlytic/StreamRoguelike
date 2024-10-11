class_name TravelAction
extends EntityAction


func _init(target: Entity):
	self.type = ActionType.TRAVEL
	self.target = target


func perform_action() -> void:
	if target.has_method("travel"):
		target.travel()
