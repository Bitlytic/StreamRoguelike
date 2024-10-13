class_name FireEffect
extends Effect


func _ready():
	MessageManager.add_message(target.grid_position, Message.new("*On fire*", BityColors.RED))


func tick_effect() -> void:
	super()
	
	var attack := Attack.new()
	
	attack.damage = randi_range(1, 2)
	attack.elemental_type = Attack.Element.FIRE
	
	target.process_attack(attack)
