class_name Weapon
extends Item

enum EffectType {
	NONE,
	STUN,
	FIRE
}

@export var dice_roll : DiceRoll

@export var effects : Array[WeaponEffect]


func get_attack() -> Attack:
	var attack := Attack.new()
	attack.effects = effects
	return attack


func _to_string() -> String:
	var str = super()
	
	str += " " + str(dice_roll)
	
	return str
