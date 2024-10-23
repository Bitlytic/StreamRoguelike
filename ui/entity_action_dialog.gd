class_name ActionDialog
extends ListDialog


signal action_selected(action: EntityAction)


var target_entity: Entity


func _ready():
	super()


func _physics_process(delta: float) -> void:
	if !visible:
		return
	
	poll_input()


func display_actions(target_entity: Entity):
	self.target_entity = target_entity
	
	var action_types : Array[int] = [ActionType.DROP_ITEM]
	
	action_types.append(ActionType.ATTACK)
	
	if !target_entity.is_character && target_entity.is_passable(null):
		action_types.append(ActionType.MOVE)
	
	if target_entity is ItemEntity:
		action_types.append(ActionType.PICK_UP)
		action_types.append(ActionType.INSPECT)
	
	if target_entity is DoorEntity:
		action_types.append(ActionType.OPEN)
		var item_slot := player.inventory.find_item_slot(ItemRegistry.KEY)
		
		if target_entity.locked && item_slot != null:
			action_types.append(ActionType.UNLOCK)
	
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
				create_button("Attack", AttackAction.new(), "A")
			ActionType.MOVE:
				create_button("Walk", MoveAction.new(), "W")
			ActionType.INSPECT:
				create_button("Inspect", InspectAction.new(target_entity.item), "I")
			ActionType.PICK_UP:
				create_button("Get", PickUpAction.new(), "G")
			ActionType.OPEN:
				var open_text := "Open"
				if target_entity.open:
					open_text = "Close"
				create_button(open_text, OpenAction.new(), "O")
			ActionType.UNLOCK:
				create_button("Unlock", UnlockAction.new(), "O")
