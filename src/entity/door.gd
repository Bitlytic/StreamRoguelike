class_name DoorEntity
extends Entity


@export var open_texture : Texture2D
@export var closed_texture : Texture2D


@export var locked := false
@export var open := false

@onready var sprite: Sprite2D = $Sprite2D


func _ready():
	super()
	update_sprite()
	entity_name = "Door"


#TODO: This can be toggled while entity on it
func toggle_open():
	open = !open
	update_sprite()


func is_passable(e: Entity) -> bool:
	return !open


func can_see_through(e: Entity) -> bool:
	return open


func update_sprite():
	if open:
		sprite.texture = open_texture
	else:
		sprite.texture = closed_texture
