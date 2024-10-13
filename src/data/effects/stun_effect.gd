class_name StunEffect
extends Effect


func _ready() -> void:
	MessageManager.add_message(target.grid_position, Message.new("*Stunned*", BityColors.PURPLE))


func tick_effect() -> void:
	super()
	
	MessageManager.add_message(target.grid_position, Message.new("*Stun*", BityColors.PURPLE))
	
	target.stunned = true
