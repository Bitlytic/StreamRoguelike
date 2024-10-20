class_name ThornsEffect
extends OnHitEffect

@export var dice_roll : DiceRoll = DiceRoll.new()
@export_range(0, 1) var effective_percentage := 0.1


func perform_effect(attack: Attack) -> void:
	dice_roll.dice_size = ceili(attack.damage * effective_percentage)
	
	var thorns_amount = dice_roll.calc()
	
	if thorns_amount:
		attack.attacker._take_damage(thorns_amount)
		var message := Message.new()
		message.color = BityColors.RED
		message.text = "-" + str(thorns_amount)
		MessageManager.add_message(attack.attacker.grid_position, message)
	
