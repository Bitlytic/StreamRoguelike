class_name Player
extends Entity

var axe : BasicWeapon = load("res://resources/weapons/axe.tres")
var sword : BasicWeapon = load("res://resources/weapons/sword.tres")

var has_moved := false


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	
	var input_direction : int = Direction.get_player_direction()
	var input_vector : Vector2i = Direction.direction_to_vector2(input_direction)
	
	var action := EntityAction.new()
	
	if input_vector:
		if _can_move_to(grid_position + input_vector):
			action.type = ActionType.MOVE
		else:
			action = AttackAction.new()
			action.weapon = sword
			action.type = ActionType.ATTACK
		action.direction = input_vector
		has_moved = true
	elif Input.is_action_just_pressed("move_wait"):
		action.type = ActionType.WAIT

	if action.type != ActionType.NONE:
		grid_world.player_input(self, action)


func _can_move_to(new_pos: Vector2i) -> bool:
	var e : Entity = grid_world.get_entity(new_pos)
	
	return e == null
