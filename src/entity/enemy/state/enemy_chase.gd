extends EnemyState


var target_position : Vector2i


func enter():
	target_position = player.grid_position


func do_process() -> EntityAction:
	var action = EntityAction.new()
	
	var can_see := GridWorld.can_see(enemy.grid_position, player.grid_position, enemy)
	
	if !can_see:
		if target_position == enemy.grid_position:
			transitioned.emit(self, "idle")
	else:
		target_position = player.grid_position
		
		var attack_action = try_attack_target(player)
		if attack_action:
			return attack_action
	
	action = move_toward_pos(target_position)
	
	if action.type == ActionType.WAIT || action.type == ActionType.NONE:
		transitioned.emit(self, "idle")
	
	return action
