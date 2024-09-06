class_name Enemy
extends Entity


@export var vision_range := 5

var a_star_grid : AStarGrid2D = AStarGrid2D.new()

var last_seen_position : Vector2i
var could_see_player := false


func _ready() -> void:
	super()
	
	last_seen_position = grid_position
	
	a_star_grid.region = Rect2i(Vector2i(0, 0), grid_world.world_size + Vector2i(1, 1))
	a_star_grid.update()
	
	grid_world.update_pathfinding(self, a_star_grid)


func do_process():
	var can_see = grid_world.can_see(grid_position, player.grid_position, self)
	
	queue_redraw()
	
	if !can_see:
		if could_see_player:
			last_seen_position = player.grid_position
			could_see_player = false
		
		if grid_position != last_seen_position:
			return move_toward_pos(last_seen_position)
		
		var action = EntityAction.new(ActionType.WAIT)
		return action
	
	last_seen_position = player.grid_position
	could_see_player = true
	
	return move_toward_pos(last_seen_position)


func move_toward_pos(pos: Vector2i) -> EntityAction:
	var path := a_star_grid.get_id_path(grid_position, pos)
	
	path.pop_front()
	
	#TODO: this crashes sometimes
	var target_direction = path[0] - grid_position
	
	var action = EntityAction.new(ActionType.MOVE, target_direction)
	
	
	return action


func _draw() -> void:
	var points = PathfindingUtil.get_line_to(grid_position, player.grid_position)
	
	for i in range(points.size() - 1):
		var p0 = points[i] * 16 + Vector2i(8, 8) - Vector2i(global_position)
		var p1 = points[i + 1] * 16 + Vector2i(8, 8) - Vector2i(global_position)
		draw_line(p0, p1, Color.RED, 2.0)
