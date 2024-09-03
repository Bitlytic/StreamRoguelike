class_name Player
extends Entity

@export var grid_world: GridWorld

@export var grid_size := Vector2(16, 16)

var has_moved := false

func _ready() -> void:
	grid_world.add_entity(self)


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	var input_direction := Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	
	if input_direction && !has_moved:
		grid_world.player_input(self, input_direction)
		has_moved = true
	elif !input_direction:
		has_moved = false
