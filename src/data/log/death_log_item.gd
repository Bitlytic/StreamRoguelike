class_name DeathLogItem
extends ActionLogItem


var killer_name : String


func _init(killer: Entity) -> void:
	self.killer_name = killer.get_entity_name()


func _to_string():
	return "You were killed by %s after %d turns." % [killer_name, LevelManager.total_turns]
