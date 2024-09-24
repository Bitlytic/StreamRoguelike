class_name EnemyState
extends State


@onready var player : Player = get_tree().get_first_node_in_group("player")
@onready var enemy : Enemy = get_owner()


func move_toward_pos(pos: Vector2i) -> EntityAction:
	
	var path := enemy.a_star_grid.get_id_path(enemy.grid_position, pos, true)
	
	path.pop_front()
	
	#TODO: This sometimes messes up when it shouldn't
	if path.size() <= 0:
		return EntityAction.new(ActionType.WAIT)
	
	#TODO: this crashes sometimes
	var target_direction = path[0] - enemy.grid_position
	
	var action = MoveAction.new()
	action.position = enemy.grid_position + target_direction
	
	var cell = GridWorld.get_cell(action.position)
	
	if action is MoveAction && cell.character:
		action = EntityAction.new(ActionType.WAIT)
	
	var door : DoorEntity = GridWorld.get_cell(action.position).get_first_match(Predicates.is_door_entity)
	
	if door && !door.locked && !door.open:
		action = OpenAction.new()
		action.target = door
	
	return action


func try_attack_target(target: Entity) -> EntityAction:
	
	var target_diff = target.grid_position - enemy.grid_position
	
	if target_diff.length() < 2:
		var attack = AttackAction.new()
		attack.position = target.grid_position
		attack.weapon = enemy.weapon
		attack.target = target
		
		return attack
	
	return null
