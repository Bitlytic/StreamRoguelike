class_name FireEffect
extends Effect



func tick_effect() -> void:
	super()
	
	print("Ouch I'm on fire!!")
	
	target._take_damage(1)
