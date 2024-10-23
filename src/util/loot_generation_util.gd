class_name LootGenerationUtil


const AXE = preload("res://resources/weapons/axe.tres")
const BOW = preload("res://resources/weapons/bow.tres")
const SPEAR = preload("res://resources/weapons/spear.tres")
const SWORD = preload("res://resources/weapons/sword.tres")

const items : Array[Weapon] = [
	AXE,
	BOW,
	SPEAR,
	SWORD
]

static var item_scene : PackedScene = preload("res://src/entity/item/item_entity.tscn")


static func generate_weapon(influence: int = 0) -> Weapon:
	var calculated_influence = influence + LevelManager.current_level
	
	var template : Weapon
	
	template = items.pick_random().duplicate(true)
	
	template.dice_roll.constant_damage = randi_range(0, 1 + calculated_influence)
	template.effects.clear()
	
	var effect_count := randi_range(0, 0 + calculated_influence)
	
	if effect_count < 0:
		effect_count = 0
	
	for i in effect_count:
		var weapon_effect = WeaponEffect.new()
		
		weapon_effect.effect_type = randi_range(1, WeaponEffect.EffectType.size() - 1)
		weapon_effect.apply_chance = randf_range(0.1 + (0.05*calculated_influence), 0.15 + (0.05*calculated_influence))
		
		template.effects.append(weapon_effect)
	
	return template


static func generate_loot(room_heat: int, dungeon_level: int) -> ItemEntity:
	
	var entity : ItemEntity = item_scene.instantiate()
	
	if room_heat > 40:
		entity.item = BOW
	elif room_heat > 10:
		entity.item = AXE
	
	return entity
