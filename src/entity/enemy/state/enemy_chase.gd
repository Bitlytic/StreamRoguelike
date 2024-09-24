extends EnemyState


var target_position : Vector2i

var could_see := false


func enter():
	target_position = player.grid_position


func do_process() -> EntityAction:
	var action = EntityAction.new()
	
	if !enemy.can_see_player:
		if could_see:
			target_position = player.grid_position
			could_see = false
		
		if target_position == enemy.grid_position:
			transitioned.emit(self, "idle")
			return EntityAction.new()
	else:
		target_position = player.grid_position
		
		could_see = true
		
		var attack_action = try_attack_target(player)
		if attack_action:
			return attack_action
	
	action = move_toward_pos(target_position)
	
	if action.type == ActionType.WAIT || action.type == ActionType.NONE:
		transitioned.emit(self, "idle")
	
	return action
