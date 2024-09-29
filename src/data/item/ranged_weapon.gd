class_name RangedWeapon
extends Resource


@export_range(0, 1) var accuracy := 0.1
@export var dice_roll : DiceRoll


func calc_damage() -> int:
	return dice_roll.calc()
