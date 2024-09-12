class_name ActionDialog
extends ListDialog


signal action_selected(action: EntityAction)



func _ready():
	connect_options(on_action_selected)


func _physics_process(delta: float) -> void:
	if !visible:
		return
	
	poll_input()
	


func display_actions(target_entity: Entity):
	var action_types : Array[int] = [ActionType.DROP_ITEM]
	
	action_types.append(ActionType.ATTACK)
	
	if !target_entity.is_character && !target_entity.blocks_movement:
		action_types.append(ActionType.MOVE)
	
	if target_entity is ItemEntity:
		action_types.append(ActionType.PICK_UP)
	
	if target_entity is DoorEntity:
		action_types.append(ActionType.OPEN)
	
	populate_options(action_types)
	
	if action_buttons.size() <= 0:
		action_selected.emit(null)
		return
	
	connect_options(on_action_selected)
	
	_change_focus(0)
	
	show()


func on_action_selected(action: Object):
	if action is EntityAction:
		action_selected.emit(action)


func populate_options(actions: Array[int]):
	clear_options()
	
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
