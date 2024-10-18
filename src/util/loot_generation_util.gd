class_name LootGenerationUtil


const AXE = preload("res://resources/weapons/axe.tres")
const BOW = preload("res://resources/weapons/bow.tres")
const SPEAR = preload("res://resources/weapons/spear.tres")
const SWORD = preload("res://resources/weapons/sword.tres")

static var item_scene : PackedScene = preload("res://src/entity/item/item_entity.tscn")


static func generate_loot(room_heat: int, dungeon_level: int) -> ItemEntity:
	
	var entity : ItemEntity = item_scene.instantiate()
	
	if room_heat > 40:
		entity.item = BOW
	elif room_heat > 10:
		entity.item = AXE
	
	return entity
