class_name Player
extends Entity

var axe : BasicWeapon = load("res://resources/weapons/axe.tres")
var sword : BasicWeapon = load("res://resources/weapons/sword.tres")

var has_moved := false
var picking_direction := false


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	
	if ActionManager.picking_action:
		return
	
	if Input.is_action_just_pressed("pick_action_menu"):
		picking_direction = true
	
	if picking_direction:
		var input_direction : int = Direction.get_player_direction()
		# TODO: Add support for current tile by checking specifically num 5
		if !input_direction:
			return
		
		picking_direction = false
		
		var target_position := grid_position + Direction.direction_to_vector2(input_direction)
		var cell : GridCell = GridWorld.get_cell(target_position)
		ActionManager.show_dialog(cell, target_position)
		var action = await ActionManager.action_picked
		
		if action is AttackAction:
			action.weapon = sword
		
		if action.type != ActionType.NONE:
			GridWorld.player_input(self, action)
	
	var input_direction : int = Direction.get_player_direction()
	var input_vector : Vector2i = Direction.direction_to_vector2(input_direction)
	
	var action := EntityAction.new()
	
	if input_vector:
		var action_position := grid_position + input_vector
		
		var cell : GridCell = GridWorld.get_cell(grid_position + input_vector)
		
		# TODO: Allow movement over entity
		if !cell || (cell.character == null && !cell.blocks_movement()):
			action = MoveAction.new()
			action.type = ActionType.MOVE
		else:
			action = AttackAction.new()
			action.weapon = sword
			action.type = ActionType.ATTACK
		action.position = action_position
		has_moved = true
	elif Input.is_action_just_pressed("move_wait"):
		action.type = ActionType.WAIT
	elif Input.is_action_just_pressed("pick_up") && GridWorld.get_cell(grid_position).has_any(Predicates.is_item_entity):
		action = PickUpAction.new()
	
	if action.type != ActionType.NONE:
		GridWorld.player_input(self, action)
