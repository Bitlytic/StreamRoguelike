class_name ShadowController
extends Node

# Based off of the Symmetric Shadowcasting article by Albert Ford:
# https://www.albertford.com/shadowcasting/#is_blocking

@onready var player : Player = get_owner()

var visible_tiles : Array[Vector2i]


func compute_fov(player: Player):
	visible_tiles.clear()
	
	var origin := player.grid_position
	
	visible_tiles.append(Vector2i(0, 0))
	
	#for cardinal in 0:
		#var quadrant = Quadrant.new(origin, cardinal)
		#
		#var first_row := Row.new(1, -1, 1)
		#scan(quadrant, first_row)
	
	var quadrant = Quadrant.new(origin, 0)
		
	var first_row := Row.new(1, -1, 1)
	scan(quadrant, first_row)


func reveal(quadrant: Quadrant, pos: Vector2i):
	var world_pos := quadrant.transform(pos - player.grid_position)
	
	if !visible_tiles.has(world_pos):
		visible_tiles.append(world_pos)


func scan(quadrant: Quadrant, row: Row):
	var prev_cell : GridCell
	
	for pos in row.get_tiles():
		var target_position : Vector2i = player.grid_position + pos
		if !GridWorld.is_in_bounds(target_position):
			return
		
		var grid_cell : GridCell = GridWorld.get_cell(player.grid_position + pos)
		
		var prev_blocks_vision = prev_cell && prev_cell.blocks_vision()
		var blocks_vision = grid_cell && grid_cell.blocks_vision()
		
		if blocks_vision || is_symmetric(row, pos):
			reveal(quadrant, pos)
		
		if prev_blocks_vision && !blocks_vision:
			row.start_slope = slope(row, pos)
		
		if !prev_blocks_vision && blocks_vision:
			var next_row = row.next()
			next_row.end_slope = slope(row, pos)
			scan(quadrant, next_row)
		
		prev_cell = grid_cell
		
	if prev_cell && !prev_cell.blocks_vision():
		scan(quadrant, row.next())


func slope(row: Row, pos: Vector2i) -> float:
	var numerator = 2.0 * pos.y - 1.0
	var denominator = 2.0 * float(row.depth)
	
	return numerator / denominator


func is_symmetric(row: Row, pos: Vector2i) -> bool:
	return (pos.y >= row.depth * row.start_slope && pos.y <= row.depth * row.end_slope)


class Quadrant:
	enum Cardinal {
		NORTH,
		EAST,
		SOUTH,
		WEST
	}
	
	var cardinal : int
	var origin: Vector2i
	
	
	func _init(origin: Vector2i, cardinal: int):
		self.origin = origin
		self.cardinal = cardinal
	
	
	func transform(pos: Vector2i) -> Vector2i:
		var float_pos := Vector2(pos)
		
		
		match cardinal:
			Cardinal.NORTH:
				return origin + Vector2i(pos.y, -pos.x)
			Cardinal.EAST:
				return origin + Vector2i(pos.x, pos.y)
			Cardinal.SOUTH:
				return origin + Vector2i(float_pos.rotated(deg_to_rad(90)))
			Cardinal.WEST:
				return origin + Vector2i(float_pos.rotated(deg_to_rad(180)))
		
		#push_error("What the fuck")
		return pos


class Row:
	
	var depth: int
	var start_slope: float
	var end_slope: float
	
	
	func _init(depth: int, start_slope: float, end_slope: float):
		self.depth = depth
		self.start_slope = start_slope
		self.end_slope = end_slope
	
	
	func next() -> Row:
		var next_row := Row.new(depth + 1, start_slope, end_slope)
		return next_row
	
	
	func get_tiles() -> Array[Vector2i]:
		var min_column := int(floor(depth*start_slope + 0.5))
		var max_column := int(ceil(depth*end_slope - 0.5))
		
		var tiles : Array[Vector2i] = []
		
		for i in range(min_column, max_column + 1):
			tiles.append(Vector2i(depth, i))
		
		return tiles
