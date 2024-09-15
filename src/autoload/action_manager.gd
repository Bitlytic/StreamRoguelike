extends Node


signal action_picked(action: EntityAction)
signal item_picked(slot: ItemSlot)


@onready var action_dialog: ActionDialog = $UI/ActionDialog
@onready var entity_dialog: EntityDialog = $UI/EntityDialog
@onready var inventory_dialog: InventoryDialog = $UI/ItemDialog
@onready var item_action_dialog: ItemActionDialog = $UI/ItemActionDialog


var picking_action := false
var picking_item := false
var target_position : Vector2i
var target_entity : Entity


func _ready():
	action_dialog.action_selected.connect(on_action_selected)
	entity_dialog.entity_selected.connect(on_entity_selected)
	inventory_dialog.item_selected.connect(on_item_selected)
	item_action_dialog.item_action_selected.connect(on_item_action_selected)
	
	action_dialog.hide()
	entity_dialog.hide()
	inventory_dialog.hide()
	item_action_dialog.hide()


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
	GridWorld.player_input(action)
	clean_up()


func on_entity_selected(entity: Entity):
	
	target_entity = entity
	
	# If entity, grab an action
	if !entity:
		picking_action = false
		on_action_selected(EntityAction.new())
		return
	entity_dialog.hide()
	
	action_dialog.display_actions(entity)


func show_inventory_dialog(inventory: Inventory) -> void:
	picking_item = true
	inventory_dialog.display_items(inventory)


func on_item_selected(slot: ItemSlot) -> void:
	
	if !slot:
		picking_item = false
		on_action_selected(EntityAction.new())
		return
	inventory_dialog.hide()
	
	item_action_dialog.display_actions(slot)


func on_item_action_selected(action: EntityAction) -> void:
	item_action_dialog.hide()
	picking_item = false
	
	GridWorld.player_input(action)
	clean_up()


func clean_up():
	action_dialog.hide()
	entity_dialog.hide()
	inventory_dialog.hide()
	item_action_dialog.hide()
	picking_action = false
	picking_item = false
