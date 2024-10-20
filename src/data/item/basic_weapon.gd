class_name BasicWeapon
extends Weapon


func get_attack() -> Attack:
	var attack := Attack.new()
	attack.damage = dice_roll.calc()
	attack.effects = effects
	attack.on_hit_effects = on_hit_effects
	return attack
