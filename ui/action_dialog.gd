extends Control


signal action_selected(action: EntityAction)


@export var action_buttons : Array[ActionButton]


@onready var button_container: VBoxContainer = $Panel/ButtonContainer

var current_focused_index := 0

var action_button_scene := preload("res://ui/action_button.tscn")


func _ready():
	for button in action_buttons:
		button.action_selected.connect(on_action_selected)


func _physics_process(delta: float) -> void:
	if !visible:
		return
	
	if Input.is_action_just_pressed("move_south"):
		_change_focus(1)
	elif Input.is_action_just_pressed("move_north"):
		_change_focus(-1)


func _change_focus(direction: int):
	
	for i in action_buttons.size():
		var button : Button = action_buttons[i]
		if button.has_focus():
			current_focused_index = i
			break
	
	current_focused_index += direction
	current_focused_index %= action_buttons.size()
	action_buttons[current_focused_index].grab_focus()
	


func display_actions(cell: GridCell):
	var action_types : Array[int] = [ActionType.DROP_ITEM]
	if !cell.blocks_movement():
		action_types.append(ActionType.MOVE)
	
	if cell.has_any(Predicates.is_item_entity):
		action_types.append(ActionType.PICK_UP)
		action_types.append(ActionType.ATTACK)
		action_types.append(ActionType.OPEN)
	
	if cell.has_any(Predicates.is_door_entity):
		action_types.append(ActionType.OPEN)
	
	populate_options(action_types)
	
	_change_focus(0)
	
	show()


func on_action_selected(action: EntityAction):
	action_selected.emit(action)


func populate_options(actions: Array[int]):
	for c in button_container.get_children():
		if c is ActionButton:
			c.queue_free()
	
	action_buttons.clear()
	
	for action in actions:
		match(action):
			ActionType.ATTACK:
				create_button("Attack", AttackAction.new())
			ActionType.MOVE:
				create_button("Move", MoveAction.new())
			ActionType.PICK_UP:
				create_button("Pick Up", PickUpAction.new())
			ActionType.OPEN:
				create_button("Open", OpenAction.new())


func create_button(text: String, action: EntityAction):
	var spawned_button : ActionButton = action_button_scene.instantiate()
	
	spawned_button.action = action
	spawned_button.action_name = text
	
	spawned_button.action_selected.connect(on_action_selected)
	
	action_buttons.append(spawned_button)
	
	button_container.add_child(spawned_button)
