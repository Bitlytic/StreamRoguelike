class_name BasicWeapon
extends Item



@export var dice_size := 6
@export var dice_roll_times := 1

@export var constant_damage := 1


func get_attack() -> Attack:
	var attack := Attack.new()
	attack.damage = calc_damage()
	return attack


func calc_damage():
	var total := 0
	
	for i in dice_roll_times:
		total += randi_range(1, dice_size)
	
	total += constant_damage
	
	return total
