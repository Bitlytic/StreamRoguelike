extends Node


var cell_values : Array[int] = []

var cells_to_check : Array[Vector2i] = []


func generate_heat_map(starting_pos: Vector2i):
	cell_values.resize(GridWorld.world_size.x * GridWorld.world_size.y)
	cell_values.fill(-1)
	
	cell_values[GridWorld.get_index_from_pos(starting_pos)] = 0
	add_neighbor_cells(starting_pos)
	
	var heat_value := 1
	
	while cells_to_check.size() > 0:
		for cell in cells_to_check:
			cell_values[GridWorld.get_index_from_pos(cell)] = heat_value
		
		heat_value += 1
		
		var current_count := cells_to_check.size()
		
		for i in current_count:
			var cell : Vector2i = cells_to_check.pop_front()
			add_neighbor_cells(cell)
	
	var output_str:= ""
	
	for i in cell_values.size():
		if i % GridWorld.world_size.x == 0:
			output_str += "\n"
		
		var val = cell_values[i]
		if val < 0:
			output_str += "."
			continue
		
		val /= 10
		
		output_str += str(val)
	
	print(output_str)


func add_neighbor_cells(pos: Vector2i):
	for direction in Direction.direction_vectors:
		var test_pos = pos + direction
		
		if !GridWorld.is_in_bounds(test_pos):
			continue
		
		if cell_values[GridWorld.get_index_from_pos(test_pos)] != -1:
			continue
		
		if cells_to_check.has(test_pos):
			continue
		
		var cell : GridCell = GridWorld.get_cell(test_pos)
		if cell.blocks_movement():
			continue
		
		cells_to_check.push_back(test_pos)


func get_room_average(room: Rect2i) -> int:
	var total = 0
	
	for x in room.size.x:
		for y in room.size.y:
			total += cell_values[GridWorld.get_index_from_pos(room.position + Vector2i(x, y))]
	
	return total / (room.size.x * room.size.y)
