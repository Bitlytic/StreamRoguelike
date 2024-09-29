class_name Weapon
extends Item

@export var dice_roll : DiceRoll

func get_attack() -> Attack:
	return Attack.new()
