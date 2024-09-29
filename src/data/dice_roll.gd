class_name DiceRoll
extends Resource


@export var dice_size := 6
@export var dice_roll_times := 1
@export var constant_damage := 1


func calc() -> int:
	var total := 0
	
	for i in dice_roll_times:
		total += randi_range(1, dice_size)
	
	total += constant_damage
	
	return total
	
