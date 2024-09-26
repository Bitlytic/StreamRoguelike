class_name Armor
extends Item

enum ArmorSlot {
	HELMET,
	CHESTPLATE,
	BOOTS
}

@export_enum("Helmet", "Chestplate", "Boots") var slot : int

@export var armor_value := 0
@export var evasion_value := 0


func get_armor() -> int:
	return armor_value


func get_evasion() -> int:
	return evasion_value
