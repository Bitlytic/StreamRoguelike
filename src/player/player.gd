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
	
	var item_predicate = func(entity: Entity):
		return entity is ItemEntity
	
	if input_vector:
		var cell : GridCell = grid_world.get_cell(grid_position + input_vector)
		
		# TODO: Allow movement over entity
		if !cell || (cell.character == null && !cell.blocks_movement()):
			action.type = ActionType.MOVE
		else:
			action = AttackAction.new()
			action.weapon = sword
			action.type = ActionType.ATTACK
		action.direction = input_vector
		has_moved = true
	elif Input.is_action_just_pressed("move_wait"):
		action.type = ActionType.WAIT
	elif Input.is_action_just_pressed("pick_up") && grid_world.get_cell(grid_position).has_any(item_predicate):
		action.type = ActionType.PICK_UP
	
	if action.type != ActionType.NONE:
		grid_world.player_input(self, action)
