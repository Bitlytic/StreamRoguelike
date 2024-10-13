class_name StunEffect
extends Effect


func _ready() -> void:
	print("Stunned!")


func tick_effect() -> void:
	super()
	
	print("Still stunned!")
	
	target.stunned = true
