class_name WeaponEffect
extends Resource


enum EffectType {
	## No effect.
	NONE,
	## Stun enemy for [code]x[/code] turns
	STUN,
	## Cause enemy to take fire damage for [code]x[/code] turns
	FIRE,
	## Cause enemy to deal less damage for [code]x[/code] turns
	WEAK,
	## Cause enemy to take more damage for [code]x[/code] turns
	VULNERABLE
}

@export var effect_type : EffectType
@export var apply_chance := 0.1
@export var turn_count := 5


func apply_effect(entity: Entity) -> void:
	var effect : Effect
	
	if randf_range(0, 1) > apply_chance:
		return
	
	match(effect_type):
		EffectType.STUN:
			effect = StunEffect.new(entity, turn_count)
		EffectType.FIRE:
			effect = FireEffect.new(entity, turn_count)
		EffectType.WEAK:
			effect = WeakEffect.new(entity, turn_count)
		EffectType.VULNERABLE:
			effect = VulnerableEffect.new(entity, turn_count)
	
	if !effect:
		return
	
	entity.effects_holder.add_child(effect)
