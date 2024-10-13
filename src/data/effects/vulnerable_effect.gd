class_name VulnerableEffect
extends Effect


func tick_effect() -> void:
	super()
	
	target.vulnerable = true
