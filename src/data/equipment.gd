class_name Equipment
extends Resource


@export var weapon : BasicWeapon
@export var ranged_weapon : RangedWeapon

@export_group("Armor")
@export var helmet : Armor
@export var chestplate : Armor
@export var boots : Armor


#TODO: Create calc armor and evasion values
func get_armor() -> int:
	var total_armor := 0
	
	if helmet:
		total_armor += helmet.get_armor()
	
	if chestplate:
		total_armor += chestplate.get_armor()
	
	if boots:
		total_armor += boots.get_armor()
	
	return total_armor


func get_evasion() -> int:
	var total_evasion := 0
	
	if helmet:
		total_evasion += helmet.get_evasion()
	
	if chestplate:
		total_evasion += chestplate.get_evasion()
	
	if boots:
		total_evasion += boots.get_evasion()
	
	return total_evasion
