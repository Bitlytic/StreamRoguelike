extends EnemyState


func do_process() -> EntityAction:
	
	if enemy.can_see_player:
		transitioned.emit(self, "chase")
	
	return EntityAction.new()
