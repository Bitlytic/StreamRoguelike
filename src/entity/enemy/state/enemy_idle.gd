extends EnemyState


func do_process() -> EntityAction:
	
	var can_see := GridWorld.can_see(enemy.grid_position, player.grid_position, enemy)
	
	if can_see:
		transitioned.emit(self, "chase")
	
	return EntityAction.new()
