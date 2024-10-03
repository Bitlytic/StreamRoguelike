class_name Item
extends Resource


@export var texture : Texture2D = AtlasTexture.new()
@export var texture_tint : Color = Color.WHITE
@export var item_name : String


func _to_string() -> String:
	return item_name
