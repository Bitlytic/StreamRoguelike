class_name Health

signal health_changed(health: float)

const property := "health"

static func get_health(node: Node) -> int:
	
	if node.has_meta(property):
		return node.get_meta(property)
	else:
		# TODO: Address this eventually
		return 0


static func set_health(node: Node, new_health: float):
	var current_health = get_health(node)
	
	node.set_meta(property, new_health)
	
	if current_health != new_health:
		health_changed.emit(new_health)
