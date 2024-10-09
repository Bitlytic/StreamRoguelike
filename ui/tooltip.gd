extends Node2D

var entity_name := "":
	set(val):
		entity_name = val
		tooltip_name.text = val
		panel.size = Vector2(0, 0)
		update_position()

var entity_description := "":
	set(val):
		entity_description = val
		tooltip_info.text = val
		update_size(val)
		panel.size = Vector2(0, 0)
		update_position()

var grid_position : Vector2i:
	set(val):
		grid_position = val
		update_position()

@export var max_characters: int = 26
@export var tooltip_name: Label
@export var tooltip_info: Label
@onready var panel: PanelContainer = $Panel


func update_position() -> void:
	var offset := 8
	
	global_position.x = grid_position.x * GridWorld.cell_size.x + offset
	global_position.y = grid_position.y * GridWorld.cell_size.y - offset
	
	if global_position.x + panel.size.x + 16 > get_viewport_rect().size.x:
		panel.position.x = -panel.size.x - offset*2
	else:
		panel.position.x = 0
	
	
	if global_position.y + panel.size.y + 16 > get_viewport_rect().size.y:
		panel.position.y = -panel.size.y + offset*2
	else:
		panel.position.y = 0


func update_size(s: String):
	if s.length() > max_characters:
		tooltip_info.custom_minimum_size.x = max_characters * 5
		tooltip_info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	else:
		tooltip_info.custom_minimum_size.x = 0
		tooltip_info.autowrap_mode = TextServer.AUTOWRAP_OFF
