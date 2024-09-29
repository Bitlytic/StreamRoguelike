class_name DoorEntity
extends Entity


@export_group("Textures")
@export var open_texture : Texture2D
@export var closed_texture : Texture2D

@export_group("Colors")
@export var locked_color : Color
@export var unlocked_color : Color


@export_group("State")
@export var locked := false
@export var open := false

@export_group("Sounds")
@export var open_sound : AudioStream
@export var close_sound : AudioStream
@export var unlock_sound : AudioStream

@onready var sprite: Sprite2D = $Sprite2D


func _ready():
	super()
	update_sprite()
	entity_name = "Door"


#TODO: This can be toggled while entity on it
func toggle_open():
	if !locked:
		open = !open
		
		if open:
			SoundManager.play_sound(open_sound, 0.25)
		else:
			SoundManager.play_sound(close_sound, 0.25)
	
	update_sprite()


func unlock():
	locked = false
	SoundManager.play_sound(unlock_sound, 0.25)
	update_sprite()


func is_passable(e: Entity) -> bool:
	return open


func can_see_through(e: Entity) -> bool:
	return open


func update_sprite():
	if open:
		sprite.texture = open_texture
	else:
		sprite.texture = closed_texture
	
	if locked:
		sprite.self_modulate = locked_color
	else:
		sprite.self_modulate = unlocked_color
