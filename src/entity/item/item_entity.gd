class_name ItemEntity
extends Entity

@export var item : Item = preload("res://resources/weapons/axe.tres")

@onready var sprite : Sprite2D = $Sprite

var count : int = 1

func _ready():
	super()
	sprite.texture = item.texture


func get_entity_name() -> String:
	return item.item_name
