extends Node


signal action_picked(action: EntityAction)
signal item_picked(slot: ItemSlot)


@onready var action_dialog: ActionDialog = $UI/ActionDialog
@onready var entity_dialog: EntityDialog = $UI/EntityDialog
@onready var item_dialog: InventoryDialog = $UI/ItemDialog


var picking_action := false
var picking_item := false
var target_position : Vector2i
var target_entity : Entity


func _ready():
	action_dialog.action_selected.connect(on_action_selected)
	entity_dialog.entity_selected.connect(on_entity_selected)
	item_dialog.item_selected.connect(on_item_selected)
	
	action_dialog.hide()
	entity_dialog.hide()
	item_dialog.hide()


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("cancel"):
		
		if picking_item:
			on_item_selected(null)
		elif picking_action:
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


func show_item_dialog(inventory: Inventory) -> void:
	picking_item = true
	item_dialog.display_items(inventory)


func on_item_selected(slot: ItemSlot):
	item_dialog.hide()
	item_picked.emit(slot)
	
	picking_item = false
