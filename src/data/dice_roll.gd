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


func get_min() -> int:
	return dice_roll_times + constant_damage


func get_max() -> int:
	return dice_size*dice_roll_times + constant_damage

func _to_string() -> String:
	var str = "%dd%d" % [dice_roll_times, dice_size]
	
	if constant_damage:
		str += " + %d" % constant_damage
	
	return str
