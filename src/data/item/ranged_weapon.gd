class_name RangedWeapon
extends Weapon


@export_range(0, 1) var accuracy : float = 0.1



func get_attack() -> Attack:
	var attack := Attack.new()
	
	if randf_range(0, 1) <= accuracy:
		attack.damage = dice_roll.calc()
	
	attack.effects = effects
	attack.on_hit_effects = on_hit_effects
	return attack
