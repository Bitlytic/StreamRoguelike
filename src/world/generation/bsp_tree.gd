class_name BSPTree

var max_size := 12
var min_size := 6
var max_leaf_size := 16
var map : Array[bool]
var leaves: Array[Leaf]


func _init():
	map.resize(GridWorld.world_size.x * GridWorld.world_size.y)

func generate():
	# Array of booleans, false means wall, true means air
	map.fill(true)
	
	leaves.clear()
	
	var root_leaf = Leaf.new(0, 0, GridWorld.world_size.x, GridWorld.world_size.y)
	
	leaves.append(root_leaf)
	
	var split_successfully := true
	
	while(split_successfully):
		split_successfully = false
		
		for leaf in leaves:
			if !leaf.child_1 && !leaf.child_2:
				if leaf.size.x > max_leaf_size || leaf.size.y > max_leaf_size:
					if leaf.split():
						leaves.append(leaf.child_1)
						leaves.append(leaf.child_2)
						split_successfully = true
	
	root_leaf.create_rooms(self)
	
	return map


func get_first_room() -> Rect2i:
	for leaf in leaves:
		if leaf.room:
			return leaf.room
	
	return Rect2i()

func get_last_room() -> Rect2i:
	var room := Rect2i()
	
	for leaf in leaves:
		if leaf.room:
			room = leaf.room
	
	return room


func create_room(room: Rect2i):
	for x in range(room.size.x):
		for y in range(room.size.y):
			map[coord_to_index(room.position.x + x, room.position.y + y)] = false


func create_hall(room1: Rect2i, room2: Rect2i):
	
	var center1 = room1.get_center()
	var center2 = room2.get_center()
	
	if randf_range(0, 1) > 0.5:
		create_horizontal_tunnel(center1.x, center2.x, center1.y)
		create_vertical_tunnel(center1.y, center2.y, center2.x)
	else:
		create_vertical_tunnel(center1.y, center2.y, center1.x)
		create_horizontal_tunnel(center1.x, center2.x, center2.y)


func create_horizontal_tunnel(x1: int, x2: int, y: int):
	var start = min(x1, x2)
	var size = abs(x1 - x2)
	for x in range(size):
		map[coord_to_index(start + x, y)] = false

func create_vertical_tunnel(y1: int, y2: int, x: int):
	var start = min(y1, y2)
	var size = abs(y1 - y2)
	for y in range(size):
		map[coord_to_index(x, start + y)] = false

func coord_to_index(x: int, y: int) -> int:
	return GridWorld.world_size.x * y + x


class Leaf:
	
	var pos : Vector2i
	var size : Vector2i
	
	var min_leaf_size := 10
	var child_1 : Leaf
	var child_2 : Leaf
	var room : Rect2i
	
	func _init(x, y, width, height):
		pos = Vector2i(x, y)
		size = Vector2i(width, height)
	
	
	# Returns whether split was successful
	func split() -> bool:
		if child_1 != null || child_2 != null:
			return false
		
		var split_horizontally : bool = randf_range(0, 1) > 0.5
		
		if float(size.x) / float(size.y) >= 1.25:
			split_horizontally = false
		elif float(size.y) / float(size.x) >= 1.25:
			split_horizontally = true
		
		var max : int
		
		if split_horizontally:
			max = size.y - min_leaf_size
		else:
			max = size.x - min_leaf_size
		
		if max <= min_leaf_size:
			return false
		
		var split = randi_range(min_leaf_size, max)
		
		if split_horizontally:
			child_1 = Leaf.new(pos.x, pos.y, size.x, split)
			child_2 = Leaf.new(pos.x, pos.y + split, size.x, size.y - split)
		else:
			child_1 = Leaf.new(pos.x, pos.y, split, size.y)
			child_2 = Leaf.new(pos.x + split, pos.y, size.x - split, size.y)
		
		return true
	
	
	func create_rooms(bsp_tree: BSPTree):
		if child_1 || child_2:
			if child_1:
				child_1.create_rooms(bsp_tree)
			if child_2:
				child_2.create_rooms(bsp_tree)
			
			if child_1 && child_2:
				bsp_tree.create_hall(child_1.get_room(), child_2.get_room())
		else:
			var width := randi_range(bsp_tree.min_size, min(bsp_tree.max_size, size.x - 1))
			var height := randi_range(bsp_tree.min_size, min(bsp_tree.max_size, size.y - 1))
			var x := randi_range(pos.x, pos.x + (size.x - 1) - width)
			var y := randi_range(pos.y, pos.y + (size.y - 1) - height)
			if x == 0:
				x += 1
			if y == 0:
				y += 1
			
			room = Rect2i(x, y, width, height)
			
			bsp_tree.create_room(room)
	
	
	func get_room() -> Rect2i:
		if room:
			return room
		
		var room_1
		if child_1:
			room_1 = child_1.get_room()
		
		var room_2
		if child_2:
			room_2 = child_2.get_room()
		
		if !room_1 && !room_2:
			return Rect2i()
		
		if !room_2:
			return room_1
		
		if !room_1:
			return room_2
		
		if randf_range(0, 1) > 0.5:
			return room_1
		else:
			return room_2
