class_name ItemEntity
extends Entity

@onready var sprite : Sprite2D = $Sprite

var item : Item = preload("res://resources/weapons/axe.tres")

func _ready():
	super()
	sprite.texture = item.texture
