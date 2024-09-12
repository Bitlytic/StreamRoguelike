class_name MoveAction
extends EntityAction


func _init():
	self.type = ActionType.MOVE


func perform_action() -> void:
	var old_pos := owner.grid_position
	owner.grid_position = position
	
	GridWorld.move_entity(owner, old_pos)
