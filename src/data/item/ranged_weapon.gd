class_name RangedWeapon
extends Weapon


@export_range(0, 1) var accuracy : float = 0.1



func get_attack() -> Attack:
	var attack := Attack.new()
	
	if randf_range(0, 1) <= accuracy:
		attack.damage = dice_roll.calc()
		print("Hit! for ", attack.damage)
	else:
		print("Miss!")
	return attack
