class_name Entity
extends Node2D


signal health_changed(new_health: int)
signal died()

@export var starting_position := Vector2i(0, 0)

@export var max_health : int = 10
@onready var health : int = max_health

@onready var grid_world : GridWorld = get_tree().get_first_node_in_group("world")

var cell_size := Vector2(16, 16)

var grid_position : Vector2i : 
	set(val):
		grid_position = val
		_update_render_position()


func _ready():
	grid_position = starting_position
	grid_world.add_entity(self)


func do_process() -> EntityAction:
	var action = EntityAction.new(ActionType.WAIT)
	return action


func _update_render_position() -> void:
	global_position = Vector2(grid_position)*cell_size


func process_attack(attack: Attack) -> void:
	_take_damage(attack.calc_damage())


func _take_damage(damage: int) -> void:
	print("Took %d damage" % damage)
	
	health -= damage
	if health <= 0:
		health = 0
		died.emit()
	else:
		health_changed.emit(health)
