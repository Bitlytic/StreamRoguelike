extends Node


signal action_picked(action: EntityAction)


@onready var action_dialog: ActionDialog = $UI/ActionDialog
@onready var entity_dialog: EntityDialog = $UI/EntityDialog


var picking_action := false
var target_position : Vector2i
var target_entity : Entity


func _ready():
	action_dialog.action_selected.connect(on_action_selected)
	entity_dialog.entity_selected.connect(on_entity_selected)


func _physics_process(delta: float) -> void:
	if picking_action && Input.is_action_just_pressed("cancel"):
		on_action_selected(EntityAction.new(ActionType.NONE))


func show_dialog(cell: GridCell, target_position: Vector2i):
	self.target_position = target_position
	picking_action = true
	
	# Grab an entity
	entity_dialog.display_entities(cell)


func on_action_selected(action: EntityAction):
	action.target = target_entity
	action.position = target_position
	action_picked.emit(action)
	action_dialog.hide()
	entity_dialog.hide()
	picking_action = false


func on_entity_selected(entity: Entity):
	
	target_entity = entity
	
	# If entity, grab an action
	if !entity:
		picking_action = false
		on_action_selected(EntityAction.new())
		return
	entity_dialog.hide()
	
	action_dialog.display_actions(entity)
