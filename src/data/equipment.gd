class_name Equipment
extends Resource


@export var weapon : BasicWeapon
@export var ranged_weapon : RangedWeapon

@export_group("Armor")
@export var helmet : Armor
@export var chestplate : Armor
@export var boots : Armor


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


func get_weight() -> float:
	var total_weight := 0
	
	if weapon:
		total_weight += weapon.weight
	
	if helmet:
		total_weight += helmet.weight
	
	if chestplate:
		total_weight += chestplate.weight
	
	if boots:
		total_weight += boots.weight
	
	return total_weight


func get_on_hit_effects() -> Array[OnHitEffect]:
	
	var on_hit_effects : Array[OnHitEffect]
	
	if helmet:
		on_hit_effects.append_array(helmet.on_hit_effects)
	
	if chestplate:
		on_hit_effects.append_array(chestplate.on_hit_effects)
	
	if boots:
		on_hit_effects.append_array(boots.on_hit_effects)
	
	return on_hit_effects
