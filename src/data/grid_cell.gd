class_name GridCell
extends RefCounted


var character : Entity
var _entities : Array[Entity]
var ambient_tile : AmbientTile

var in_vision := false

var displayed := true

# Can't be larger than entity count (if character is there, otherwise count - 1)
var current_display_index : int = 0

var grid_position : Vector2i


func _init(pos: Vector2i):
	grid_position = pos


func reset_display() -> void:
	current_display_index = 0
	_display_entity()


func cycle_display() -> void:
	current_display_index += 1
	var total_count = _entities.size()
	
	if character:
		total_count += 1
	
	if total_count <= 0:
		return
	
	current_display_index %= total_count
	
	_display_entity()


func set_display(b: bool) -> void:
	displayed = b
	_display_entity()

func _display_entity() -> void:
	var index_offset = 0
	
	if character && character.in_vision:
		character.visible = current_display_index == 0 && displayed
		index_offset = 1
	
	for index in _entities.size():
		var e: Entity = _entities[index]
		e.visible = index + index_offset == current_display_index && displayed


func add_entity(e: Entity) -> void:
	if e.is_character:
		character = e
	else:
		_entities.append(e)


func remove_entity(e: Entity) -> void:
	if e.is_character && character == e:
		character = null
	else:
		_entities.erase(e)


func get_entities() -> Array[Entity]:
	return _entities


func get_entity_count() -> int:
	var total = _entities.size()
	
	if character:
		total += 1
	
	return total


func blocks_movement() -> bool:
	if character:
		return true
	
	for e in _entities:
		if !e.is_passable(null):
			return true
	
	return false


func blocks_vision() -> bool:
	if character && !character.can_see_through(null):
		return true
	
	for e in _entities:
		if !e.can_see_through(null):
			return true
	
	return false


func has_any(test_func : Callable) -> bool:
	if test_func.call(character):
		return true
	
	for e in _entities:
		if test_func.call(e):
			return true
	
	return false


func get_first_match(test_func : Callable) -> Entity:
	if test_func.call(character):
		return character
	
	for e in _entities:
		if test_func.call(e):
			return e
	
	return null


func set_player_visible(v: bool) -> void:
	for e in get_entities():
		e.in_vision = v
	
	if character:
		character.in_vision = v
	
	if ambient_tile:
		ambient_tile.in_vision = v
	
	in_vision = v
