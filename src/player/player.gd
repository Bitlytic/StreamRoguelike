class_name Player
extends Entity


@onready var animation_controller: AnimationController = $AnimationController


var axe : BasicWeapon = load("res://resources/weapons/axe.tres")

var has_moved := false
var picking_direction := false
var picking_item := false


@onready var weapon : BasicWeapon = axe


func _ready():
	super()
	
	health_changed.connect(on_health_changed)
	on_health_changed(health)


func _physics_process(delta: float) -> void:
	
	if ActionManager.picking_action || ActionManager.picking_item:
		return
	
	if Input.is_action_just_pressed("pick_action_menu"):
		picking_direction = true
		ActionManager.show_picking_direction()
	
	if Input.is_action_just_pressed("equip_item_menu"):
		ActionManager.show_inventory_dialog(inventory)
		return
	
	if picking_direction:
		var input_direction : int = Direction.get_player_direction()
		var input_center := Input.is_action_just_pressed("move_wait")
		
		if Input.is_action_just_pressed("cancel"):
			picking_direction = false
			ActionManager.hide_top_bar()
			return
		
		if !input_direction && !input_center:
			return
		
		ActionManager.hide_top_bar()
		
		picking_direction = false
		
		var target_direction := Direction.direction_to_vector2(input_direction)
		
		var target_position := grid_position + target_direction
		var cell : GridCell = GridWorld.get_cell(target_position)
		ActionManager.show_dialog(cell, target_position)
		return
	
	var input_direction : int = Direction.get_player_direction()
	var input_vector : Vector2i = Direction.direction_to_vector2(input_direction)
	
	var action := EntityAction.new()
	
	if input_vector:
		var action_position := grid_position + input_vector
		
		var cell : GridCell = GridWorld.get_cell(grid_position + input_vector)
		
		if !cell || (cell.character == null && !cell.blocks_movement()):
			action = MoveAction.new()
			action.type = ActionType.MOVE
		elif cell.character:
			action = AttackAction.new()
			action.weapon = weapon
			action.type = ActionType.ATTACK
			action.target = cell.character
		elif cell.has_any(Predicates.is_door_entity):
			var door = cell.get_first_match(Predicates.is_door_entity)
			var item_slot := inventory.find_item_slot(ItemRegistry.KEY)
			
			if door.locked && item_slot != null:
				action = UnlockAction.new(item_slot, door)
			elif !door.locked && !door.open:
				action = OpenAction.new()
				action.target = door
		action.position = action_position
		has_moved = true
	elif Input.is_action_just_pressed("move_wait"):
		action.type = ActionType.WAIT
	elif Input.is_action_just_pressed("pick_up") && GridWorld.get_cell(grid_position).has_any(Predicates.is_item_entity):
		action = PickUpAction.new()
	
	if action.type != ActionType.NONE:
		GridWorld.player_input(action)


func play_attack_animation(action: AttackAction):
	var direction = action.target.grid_position - grid_position
	
	direction.x = clamp(direction.x, -1, 1)
	direction.y = clamp(direction.y, -1, 1)
	
	animation_controller.play_attack_animation(Direction.vector2_to_direction(direction))


func on_health_changed(_new_health: int) -> void:
	PlayerEventBus.health_changed.emit(self)
