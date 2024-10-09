extends Control


var attack : Attack

@onready var damage_text: Label = $DamageText


func _ready():
	damage_text.text = "-" + str(attack.damage)
	global_position += Vector2(randf_range(-4, 4), randf_range(-4, 4))
	var s = randf_range(0.9, 1.1)
	scale.x = s
	scale.y = s
