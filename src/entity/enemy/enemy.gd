class_name Enemy
extends Entity


@export var debug_draw := false

@export var vision_range := 8

@onready var animation_controller: AnimationController = $AnimationController

var weapon : BasicWeapon = preload("res://resources/weapons/axe.tres")

var a_star_grid : AStarGrid2D = AStarGrid2D.new()

var last_seen_position : Vector2i
var could_see_player := false

var reaction_time := 1
var current_player_reaction_time := 0


func _ready() -> void:
	super()
	
	last_seen_position = grid_position
	
	a_star_grid.region = Rect2i(Vector2i(0, 0), GridWorld.world_size + Vector2i(1, 1))
	a_star_grid.update()
	
	GridWorld.update_pathfinding(self, a_star_grid)


func do_process():
	#TODO: If performance sucks, this is probably why
	GridWorld.update_pathfinding(self, a_star_grid)
	
	var can_see = GridWorld.can_see(grid_position, player.grid_position, self)
	
	queue_redraw()
	
	# TODO: Make this a state machine eventually
	
	if !can_see:
		if could_see_player:
			last_seen_position = player.grid_position
			could_see_player = false
		else:
			current_player_reaction_time = 0
		
		if grid_position != last_seen_position:
			var action = move_toward_pos(last_seen_position)
			#TODO: This probably won't matter when we use a state machine
			if action.type == ActionType.WAIT:
				last_seen_position = grid_position
			return action
		
		var action = EntityAction.new(ActionType.WAIT)
		return action
	
	if current_player_reaction_time < reaction_time:
		current_player_reaction_time += 1
		could_see_player = true
		return EntityAction.new(ActionType.WAIT)
	
	last_seen_position = player.grid_position
	
	var player_diff = player.grid_position - grid_position
	
	if player_diff.length() < 2:
		var attack = AttackAction.new()
		attack.position = player.grid_position
		attack.weapon = weapon
		attack.target = player
		
		return attack
	
	return move_toward_pos(last_seen_position)


func move_toward_pos(pos: Vector2i) -> EntityAction:
	
	var path := a_star_grid.get_id_path(grid_position, pos, true)
	
	path.pop_front()
	
	#TODO: This sometimes messes up when it shouldn't
	if path.size() <= 0:
		return EntityAction.new(ActionType.WAIT)
	
	#TODO: this crashes sometimes
	var target_direction = path[0] - grid_position
	
	var action = MoveAction.new()
	action.position = grid_position + target_direction
	
	var door : DoorEntity = GridWorld.get_cell(action.position).get_first_match(Predicates.is_door_entity)
	
	if door && !door.locked:
		action = OpenAction.new()
		action.target = door
	
	return action


func _draw() -> void:
	if !debug_draw:
		return
	
	var points = PathfindingUtil.get_line_to(grid_position, player.grid_position)
	
	var can_see = GridWorld.can_see(grid_position, player.grid_position, self)
	
	var draw_color := Color.RED
	
	if can_see:
		draw_color = Color.GREEN
	
	for i in range(points.size() - 1):
		var p0 = points[i] * 16 - Vector2i(global_position)
		var p1 = points[i + 1] * 16 - Vector2i(global_position)
		draw_line(p0, p1, draw_color, 2.0)


func get_entity_name() -> String:
	return "Enemy >:("


func play_attack_animation(action: AttackAction):
	var direction = action.target.grid_position - grid_position
	
	direction.x = clamp(direction.x, -1, 1)
	direction.y = clamp(direction.y, -1, 1)
	
	animation_controller.play_attack_animation(Direction.vector2_to_direction(direction))
