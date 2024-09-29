class_name BasicWeapon
extends Item


@export var dice_roll : DiceRoll


func get_attack() -> Attack:
	var attack := Attack.new()
	attack.damage = calc_damage()
	return attack


func calc_damage() -> int:
	return dice_roll.calc()
