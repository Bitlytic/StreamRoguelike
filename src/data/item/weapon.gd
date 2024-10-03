class_name Weapon
extends Item

@export var dice_roll : DiceRoll

func get_attack() -> Attack:
	return Attack.new()


func _to_string() -> String:
	var str = super()
	
	str += " " + str(dice_roll)
	
	return str
