class_name GridCell


var character : Entity
var _entities : Array[Entity]

# Can't be larger than entity count (if character is there, otherwise count - 1)
var current_display_index : int = 0


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


func _display_entity() -> void:
	var index_offset = 0
	
	if character:
		character.visible = current_display_index == 0
		index_offset = 1
	
	for index in _entities.size():
		var e: Entity = _entities[index]
		e.visible = index + index_offset == current_display_index


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


func blocks_movement() -> bool:
	if character:
		return true
	
	for e in _entities:
		if e.blocks_movement:
			return true
	
	return false


func blocks_vision() -> bool:
	if character && character.blocks_vision:
		return true
	
	for e in _entities:
		if e.blocks_vision:
			return true
	
	return false


func has_any(test_func : Callable) -> bool:
	if test_func.call(character):
		return true
	
	for e in _entities:
		if test_func.call(e):
			return true
	
	return false
