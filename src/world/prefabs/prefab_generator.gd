class_name PrefabGenerator


static var _r : Array[PackedScene] = [
	preload("res://src/world/prefabs/3x3-key.tscn"),
	preload("res://src/world/prefabs/3x3.tscn"),
	preload("res://src/world/prefabs/5x5.tscn"),
	preload("res://src/world/prefabs/9x9.tscn"),
]


static var rooms : Dictionary


static func generate_room(max_size: Vector2i) -> PrefabRoom:
	var valid_rooms = get_valid_rooms(max_size)
	
	return valid_rooms.pick_random().instantiate()


static func _static_init() -> void:
	for room : PackedScene in _r:
		register_room(room)


static func register_room(room: PackedScene) -> void:
	# The first export in prefab_room.gd **MUST** be the room size
	var variants = room._bundled.get("variants", null)
	if !variants:
		return
	var size : Vector2i = variants[1]
	
	var stored_rooms = rooms.get(size, [])
	
	stored_rooms.append(room)
	
	rooms[size] = stored_rooms


static func get_valid_rooms(max_size: Vector2i):
	var valid_rooms = []
	
	for size in rooms.keys():
		if size <= max_size:
			valid_rooms.append_array(rooms.get(size, []))
	
	return valid_rooms
