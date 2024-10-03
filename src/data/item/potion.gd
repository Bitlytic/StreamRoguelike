class_name Potion
extends Item


@export var dice_roll : DiceRoll


func use_item(target : Entity):
	target.heal(calc_health())


func calc_health() -> int:
	return dice_roll.calc()


func _to_string() -> String:
	var str = super()
	
	str += " " + str(dice_roll)
	
	return str
