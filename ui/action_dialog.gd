extends Control


signal action_selected(action: EntityAction)


@export var action_buttons : Array[ActionButton]


@onready var button_container: VBoxContainer = $Panel/ButtonContainer

var action_button_scene := preload("res://ui/action_button.tscn")


func _ready():
	for button in action_buttons:
		button.action_selected.connect(on_action_selected)


func display_actions(cell: GridCell):
	var action_types : Array[int] = [ActionType.DROP_ITEM]
	if !cell.blocks_movement():
		action_types.append(ActionType.MOVE)
	
	if cell.has_any(Predicates.is_item_entity):
		action_types.append(ActionType.PICK_UP)
	
	populate_options(action_types)
	
	show()


func on_action_selected(action: EntityAction):
	action_selected.emit(action)


func populate_options(actions: Array[int]):
	for c in button_container.get_children():
		if c is ActionButton:
			c.queue_free()
	
	for action in actions:
		match(action):
			ActionType.ATTACK:
				create_button("Attack", AttackAction.new())
			ActionType.MOVE:
				create_button("Move", EntityAction.new(ActionType.MOVE))
			ActionType.PICK_UP:
				create_button("Pick Up", EntityAction.new(ActionType.PICK_UP))


func create_button(text: String, action: EntityAction):
	var spawned_button : ActionButton = action_button_scene.instantiate()
	
	spawned_button.action = action
	spawned_button.action_name = text
	
	spawned_button.action_selected.connect(on_action_selected)
	
	button_container.add_child(spawned_button)
