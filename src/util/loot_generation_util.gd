class_name LootGenerationUtil


const axes : Array[Weapon] = [
	preload("res://resources/weapons/bronze_axe.tres"),
	preload("res://resources/weapons/iron_axe.tres")
]

const swords : Array[Weapon] = [
	preload("res://resources/weapons/bronze_sword.tres"),
	preload("res://resources/weapons/iron_sword.tres")
]

const spears : Array[Weapon] = [
	preload("res://resources/weapons/bronze_spear.tres"),
	preload("res://resources/weapons/iron_spear.tres")
]

const weapon_types : Array[Array] = [
	axes,
	swords,
	spears,
]


static var item_scene : PackedScene = preload("res://src/entity/item/item_entity.tscn")

enum UpgradeType {
	NONE,
	TIER,
	EFFECT
}


static func generate_weapon(influence: int = 0) -> Weapon:
	var calculated_influence = influence + LevelManager.current_level
	
	var num_of_upgrades := 0
	
	if calculated_influence <= 1:
		num_of_upgrades = 0
	elif calculated_influence <= 3:
		num_of_upgrades = 1
	elif calculated_influence <= 4:
		num_of_upgrades = 2
	elif calculated_influence <= 5:
		num_of_upgrades = 4
	else:
		num_of_upgrades = 5
	
	var weapon_effects : Array[WeaponEffect]
	var on_hit_effects : Array[OnHitEffect]
	
	var weapon_tier := 0
	
	for i in num_of_upgrades:
		var upgrade : UpgradeType = get_upgrade_type(calculated_influence)
		
		print(upgrade)
		
		if upgrade:
			print("Upgrading a weapon!")
		
		match(upgrade):
			UpgradeType.TIER:
				weapon_tier += 1
			UpgradeType.EFFECT:
				if randf_range(0, 1) > 0.5:
					on_hit_effects.append(generate_on_hit_effect(calculated_influence))
				else:
					weapon_effects.append(generate_effect(calculated_influence))
	
	
	var weapon_type : Array[Weapon] = weapon_types.pick_random()
	
	if weapon_tier >= weapon_type.size():
		weapon_tier = weapon_type.size() - 1
	
	var template : Weapon = weapon_type[weapon_tier].duplicate(true)
	
	consolidate_effects(template, weapon_effects, on_hit_effects)
	
	return template


static func generate_on_hit_effect(influence: int) -> OnHitEffect:
	
	var effects : Array[OnHitEffect] = [LifeStealEffect.new()]
	
	var effect : OnHitEffect = effects.pick_random()
	
	effect.effective_percentage = randf_range(0.05, 0.2)
	effect.chance = randf_range(0.05, 0.2)
	
	return effect


static func generate_effect(influence: int) -> WeaponEffect:
	
	var effect := WeaponEffect.new()
	
	effect.effect_type = randi_range(1, WeaponEffect.EffectType.MAX-1)
	
	
	if influence <= 3:
		effect.apply_chance = randf_range(0.05, 0.12)
		effect.turn_count = randi_range(1, 2)
	elif influence <= 4:
		effect.apply_chance = randf_range(0.1, 0.17)
		effect.turn_count = randi_range(3, 5)
	elif influence <= 5:
		effect.apply_chance = randf_range(0.17, 0.25)
		effect.turn_count = randi_range(4, 7)
	else:
		effect.apply_chance = randf_range(0.2, 0.3)
		effect.turn_count = randi_range(5, 8)
	
	return effect


static func get_upgrade_type(influence: int) -> UpgradeType:
	
	var upgrade_type : UpgradeType
	
	var chance := 0.0
	
	if influence <= 3:
		chance = 0.15
	elif influence <= 4:
		chance = 0.25
	elif influence <= 5:
		chance = 0.35
	else:
		chance = 0.5
	
	if randf_range(0, 1) < chance:
		upgrade_type = UpgradeType.TIER
	elif randf_range(0, 1) < chance:
		upgrade_type = UpgradeType.EFFECT
	
	return upgrade_type


static func consolidate_effects(weapon: Weapon, weapon_effects: Array[WeaponEffect], on_hit_effects : Array[OnHitEffect]):
	if weapon_effects.size() > 1:
		print("Consolidation!")
	
	if on_hit_effects.size() > 1:
		print("Consolidation!")
	
	# {EffectType: WeaponEffect}
	var consolidated_effects : Dictionary
	
	weapon_effects.append_array(weapon.effects)
	
	for effect in weapon_effects:
		var stored_effect : WeaponEffect = consolidated_effects.get(effect.effect_type, null)
		
		if stored_effect:
			stored_effect.apply_chance += (1 - stored_effect.apply_chance) * effect.apply_chance
		else:
			stored_effect = effect
		
		consolidated_effects[effect.effect_type] = stored_effect
	
	var consolidated_on_hit_effects : Dictionary
	
	on_hit_effects.append_array(weapon.on_hit_effects)
	
	for effect in on_hit_effects:
		var stored_effect : OnHitEffect = consolidated_on_hit_effects.get(effect.get_class(), null)
		
		if stored_effect:
			stored_effect.chance += (1 - stored_effect.chance) * effect.chance
		else:
			stored_effect = effect
		
		consolidated_on_hit_effects[effect.get_class()] = stored_effect
	
	var effects_array : Array[WeaponEffect]
	
	for effect: WeaponEffect in consolidated_effects.values():
		effects_array.append(effect)
	
	var on_hit_effects_array : Array[OnHitEffect]
	
	for effect: OnHitEffect in consolidated_on_hit_effects.values():
		on_hit_effects_array.append(effect)
	
	weapon.effects = effects_array
	weapon.on_hit_effects = on_hit_effects_array
