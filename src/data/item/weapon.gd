class_name Weapon
extends Item

enum EffectType {
	NONE,
	STUN,
	FIRE
}

@export var dice_roll : DiceRoll

@export var effects : Array[WeaponEffect]
@export var on_hit_effects : Array[OnHitEffect]


func get_attack() -> Attack:
	var attack := Attack.new()
	attack.effects = effects
	attack.on_hit_effects = on_hit_effects
	return attack


func _to_string() -> String:
	var str = super()
	
	str += " " + str(dice_roll)
	
	return str
