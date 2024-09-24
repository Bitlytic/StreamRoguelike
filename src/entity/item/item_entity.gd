@tool
class_name ItemEntity
extends Entity

@export var item : Item = preload("res://resources/weapons/axe.tres") :
	set(val):
		item = val
		update_sprite()

@onready var sprite : Sprite2D = $Sprite

var count : int = 1


func _ready():
	if !Engine.is_editor_hint():
		super()
	update_sprite()


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		global_position = (global_position / GridWorld.cell_size).floor() * GridWorld.cell_size + Vector2(8, 8)



func get_entity_name() -> String:
	return item.item_name


func update_sprite():
	if sprite:
		sprite.texture = item.texture
