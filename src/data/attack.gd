class_name Attack

var constant_damage := 1

var dice_size := 6
var dice_roll_times := 1


func calc_damage():
	var total := 0
	
	for i in dice_roll_times:
		total += randi_range(1, dice_size)
	
	total += constant_damage
	
	return total
