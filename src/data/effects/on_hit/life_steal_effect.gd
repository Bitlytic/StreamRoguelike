class_name LifeStealEffect
extends OnHitEffect


@export_range(0, 1) var chance := 0.1
@export_range(0, 1) var effective_percentage := 0.1


func perform_effect(attack: Attack) -> void:
	if randf_range(0, 1) >= chance:
		return
	
	var heal_amount = ceil(attack.damage * effective_percentage)
	attack.attacker.heal(heal_amount)
