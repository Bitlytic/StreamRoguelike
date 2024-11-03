class_name CombatLogItem
extends ActionLogItem


var enemy_name : String
var damage_to_player : int


func _init(enemy_name : String, damage_to_player : int):
	self.enemy_name = enemy_name
	self.damage_to_player = damage_to_player


func _to_string():
	var s = "You killed %s." % [enemy_name]
	
	if damage_to_player:
		s += " You took %d damage from them!" % [damage_to_player]
	
	return s
