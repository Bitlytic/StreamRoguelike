class_name Direction


enum {
	NONE,
	NORTH,
	NORTH_EAST,
	EAST,
	SOUTH_EAST,
	SOUTH,
	SOUTH_WEST,
	WEST,
	NORTH_WEST
}

static var direction_vectors : Array[Vector2] = [
	Vector2(0, 0),
	Vector2(0, -1),
	Vector2(1, -1),
	Vector2(1, 0),
	Vector2(1, 1),
	Vector2(0, 1),
	Vector2(-1, 1),
	Vector2(-1, 0),
	Vector2(-1, -1),
]


static func get_player_direction() -> int:
	if Input.is_action_just_pressed("move_north"):
		return NORTH
	elif Input.is_action_just_pressed("move_north_east"):
		return NORTH_EAST
	elif Input.is_action_just_pressed("move_east"):
		return EAST
	elif Input.is_action_just_pressed("move_south_east"):
		return SOUTH_EAST
	elif Input.is_action_just_pressed("move_south"):
		return SOUTH
	elif Input.is_action_just_pressed("move_south_west"):
		return SOUTH_WEST
	elif Input.is_action_just_pressed("move_west"):
		return WEST
	elif Input.is_action_just_pressed("move_north_west"):
		return NORTH_WEST
	return NONE


static func direction_to_vector2(dir: int) -> Vector2i:
	return direction_vectors[dir]
