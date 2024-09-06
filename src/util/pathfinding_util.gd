class_name PathfindingUtil


static func get_line_to(from: Vector2i, to: Vector2i) -> Array[Vector2i]:
	
	# Algo taken from https://forum.godotengine.org/t/tile-based-line-drawing-algorithm-efficiency/26998
	var points : Array[Vector2i] = []
	var dx = abs(to.x - from.x)
	var dy = -abs(to.y - from.y)
	var err = dx + dy
	var e2 = 2 * err
	var sx = 1 if from.x < to.x else -1
	var sy = 1 if from.y < to.y else -1
	while true:
		points.append(Vector2i(from.x, from.y))
		if from.x == to.x and from.y == to.y:
			break
		e2 = 2 * err
		if e2 >= dy:
			err += dy
			from.x += sx
		if e2 <= dx:
			err += dx
			from.y += sy
	return points
