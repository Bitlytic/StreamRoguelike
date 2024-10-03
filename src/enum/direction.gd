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

static var direction_vectors : Array[Vector2i] = [
	Vector2i(0, 0),
	Vector2i(0, -1),
	Vector2i(1, -1),
	Vector2i(1, 0),
	Vector2i(1, 1),
	Vector2i(0, 1),
	Vector2i(-1, 1),
	Vector2i(-1, 0),
	Vector2i(-1, -1),
]


static func get_player_direction() -> int:
	if Input.is_action_pressed("move_north"):
		return NORTH
	elif Input.is_action_pressed("move_north_east"):
		return NORTH_EAST
	elif Input.is_action_pressed("move_east"):
		return EAST
	elif Input.is_action_pressed("move_south_east"):
		return SOUTH_EAST
	elif Input.is_action_pressed("move_south"):
		return SOUTH
	elif Input.is_action_pressed("move_south_west"):
		return SOUTH_WEST
	elif Input.is_action_pressed("move_west"):
		return WEST
	elif Input.is_action_pressed("move_north_west"):
		return NORTH_WEST
	return NONE


static func direction_to_vector2(dir: int) -> Vector2i:
	return direction_vectors[dir]


static func vector2_to_direction(v: Vector2i) -> int:
	for i in direction_vectors.size():
		if v == direction_vectors[i]:
			return i
	
	return 0


static func direction_to_string(dir: int) -> String:
	match(dir):
		NORTH:
			return "north"
		NORTH_EAST:
			return "north_east"
		EAST:
			return "east"
		SOUTH_EAST:
			return "south_east"
		SOUTH:
			return "south"
		SOUTH_WEST:
			return "south_west"
		WEST:
			return "west"
		NORTH_WEST:
			return "north_west"
	
	return ""
