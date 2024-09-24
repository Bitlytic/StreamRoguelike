class_name Entity
extends Node2D


signal health_changed(new_health: int)
signal died(entity: Entity)


const SPRITE_OFFSET := Vector2(8, 0)


@export var max_health : int = 10
@onready var health : int = max_health

@export var is_character := false

@export var blocks_vision := false
@export var blocks_movement := false

@export var entity_name : String = ""

@export_group("Vision Colors")
@export var discovered_color := Color("#434343")
@export var vision_color := Color("#FFFFFF")

@onready var player : Player = get_tree().get_first_node_in_group("player")

var discovered := false
var in_vision := false :
	set(val):
		in_vision = val
		on_vision_changed()

var processed_this_frame := false

var inventory := Inventory.new()

var cell_size := Vector2(16, 16)

var grid_position : Vector2i : 
	set(val):
		grid_position = val
		_update_render_position()


func _ready():
	grid_position = global_position / GridWorld.cell_size.floor()
	
	GridWorld.add_entity(self)


func do_process() -> EntityAction:
	return EntityAction.new()


func _update_render_position() -> void:
	global_position = Vector2(grid_position)*cell_size


func process_attack(attack: Attack) -> void:
	_take_damage(attack.damage)


func _take_damage(damage: int) -> void:
	health -= damage
	if health <= 0:
		health = 0
		died.emit(self)
		queue_free()
	else:
		health_changed.emit(health)


func heal(amount: int) -> void:
	
	health += amount
	if health > max_health:
		health = max_health
	
	health_changed.emit(health)


func is_passable(e: Entity) -> bool:
	return blocks_movement


func can_see_through(e: Entity) -> bool:
	return !blocks_vision


func get_entity_name() -> String:
	if entity_name:
		return entity_name
	return "<NULL>"


func on_vision_changed() -> void:
	if in_vision:
		discovered = true
		modulate = vision_color
	else:
		if discovered && !is_character:
			modulate = discovered_color
		else:
			modulate = Color(0, 0, 0, 0)
