class_name Enemy
extends Entity


@export var debug_draw := false

@export var vision_range := 8

@onready var state_machine : StateMachine = $StateMachine
@onready var animation_controller: AnimationController = $AnimationController
@onready var sight_controller: SightController = $SightController

var a_star_grid : AStarGrid2D = AStarGrid2D.new()

var last_seen_position : Vector2i
var could_see_player := false

var reaction_time := 1
var current_player_reaction_time := 0

var can_see_player := false

func _ready() -> void:
	super()
	
	last_seen_position = grid_position
	
	a_star_grid.region = Rect2i(Vector2i(0, 0), GridWorld.world_size + Vector2i(1, 1))
	a_star_grid.update()
	
	sight_controller.vision_range = vision_range
	
	GridWorld.update_pathfinding(self, a_star_grid)


func do_process():
	#TODO: If performance sucks, this is probably why
	GridWorld.update_pathfinding(self, a_star_grid)
	
	
	# TODO: Performance sometimes sucks, this is the reason.
	# One optimization is to only update fov in the player direction
	# Another is to only check the fov from the player, and use that to determine enemy fov
	if in_vision:
		var dist_to_player := player.grid_position.distance_to(grid_position)
		can_see_player = dist_to_player <= vision_range
	else:
		can_see_player = false
	
	var action = state_machine.do_process()
	
	#var can_see = GridWorld.can_see(grid_position, player.grid_position, self)
	
	queue_redraw()
	return action


func _draw() -> void:
	if !debug_draw:
		return
	
	var points = PathfindingUtil.get_line_to(grid_position, player.grid_position)
	
	var draw_color := Color.RED
	
	if can_see_player:
		draw_color = Color.GREEN
	
	for i in range(points.size() - 1):
		var p0 = points[i] * 16 - Vector2i(global_position)
		var p1 = points[i + 1] * 16 - Vector2i(global_position)
		draw_line(p0, p1, draw_color, 2.0)
	
	
	for pos in sight_controller.visible_tiles:
		var world_coords : Vector2 = GridWorld.cell_size * (pos - Vector2(grid_position))
		
		draw_circle(world_coords, 4.0, Color.RED)


func get_entity_name() -> String:
	return "Enemy >:("


func play_attack_animation(action: AttackAction):
	var direction = action.target.grid_position - grid_position
	
	direction.x = clamp(direction.x, -1, 1)
	direction.y = clamp(direction.y, -1, 1)
	
	animation_controller.play_attack_animation(Direction.vector2_to_direction(direction))


func check_for_player() -> bool:
	return sight_controller.visible_tiles.has(Vector2(player.grid_position))


func get_description() -> String:
	return "A bad dude, he wants to hurt you\nHP: %d/%d" % [health, max_health]
	
	
