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

const description_template := \
"""\
Damage range: {min} - {max}
"""


func get_attack() -> Attack:
	var attack := Attack.new()
	attack.effects = effects
	attack.on_hit_effects = on_hit_effects
	return attack


func _to_string() -> String:
	var str = super()
	
	str += " " + str(dice_roll)
	
	return str


func get_description() -> String:
	var weapon_effect_names : String
	
	for effect in effects:
		weapon_effect_names += str(effect) + ", "
	
	for effect in on_hit_effects:
		weapon_effect_names += str(effect) + ", "
	
	weapon_effect_names = weapon_effect_names.trim_suffix(", ")
	
	var parameters := {
		"name": _to_string(),
		"min": dice_roll.get_min(),
		"max": dice_roll.get_max(),
	}
	
	var description = description_template.format(parameters)
	
	if weapon_effect_names:
		description += "\nEffects: %s" % weapon_effect_names
	
	return description
