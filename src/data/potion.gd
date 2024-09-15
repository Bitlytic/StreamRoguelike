class_name Potion
extends Item


@export var dice_size := 6
@export var rolls := 2
@export var constant_amount := 0


func use_item(target : Entity):
	target.heal(calc_health())


func calc_health():
	var total := 0
	
	for i in rolls:
		total += randi_range(1, dice_size)
	
	total += constant_amount
	
	return total

	
