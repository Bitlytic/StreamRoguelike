extends Node


signal action_picked(action: EntityAction)
signal item_picked(slot: ItemSlot)


@onready var action_dialog: ActionDialog = $UI/ActionDialog
@onready var entity_dialog: EntityDialog = $UI/EntityDialog
@onready var inventory_dialog: InventoryDialog = $UI/ItemDialog
@onready var equipment_dialog: EquipmentDialog = $UI/EquipmentDialog
@onready var equipment_action_dialog: EquipmentActionDialog = $UI/EquipmentActionDialog
@onready var item_action_dialog: ItemActionDialog = $UI/ItemActionDialog
@onready var item_description_dialog: ItemDescriptionDialog = $UI/ItemDescriptionDialog
@onready var top_bar: TopBar = $HUD/TopBar


var picking_action := false
var picking_item := false
var aiming := false
var target_position : Vector2i
var target_entity : Entity


func _ready():
	action_dialog.action_selected.connect(on_action_selected)
	entity_dialog.entity_selected.connect(on_entity_selected)
	inventory_dialog.item_selected.connect(on_item_selected)
	equipment_dialog.equipment_selected.connect(on_equipment_selected)
	item_action_dialog.item_action_selected.connect(on_item_action_selected)
	equipment_action_dialog.equipment_action_selected.connect(on_item_action_selected)
	item_description_dialog.description_closed.connect(on_description_closed)
	
	clean_up()
	
	hide_top_bar()


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
	if action is InspectAction:
		show_description_dialog(action)
		return
	
	if target_entity && is_instance_valid(target_entity):
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


func show_equipment_dialog(equipment: Equipment) -> void:
	picking_item = true
	equipment_dialog.display_items(equipment)


func show_inventory_dialog(inventory: Inventory) -> void:
	picking_item = true
	inventory_dialog.display_items(inventory)


func on_item_selected(slot: ItemSlot) -> void:
	
	if !slot:
		on_action_selected(EntityAction.new())
		return
	inventory_dialog.hide()
	
	item_action_dialog.display_actions(slot)


func on_item_action_selected(action: EntityAction) -> void:
	if action is InspectAction:
		show_description_dialog(action)
		return
	
	item_action_dialog.hide()
	picking_item = false
	
	GridWorld.player_input(action)
	clean_up()


func on_equipment_selected(item: Item) -> void:
	if !item:
		on_action_selected(EntityAction.new())
		return
	
	picking_item = true
	equipment_action_dialog.display_actions(item)


func on_description_closed() -> void:
	clean_up()


func show_description_dialog(action: InspectAction) -> void:
	clean_up()
	picking_item = true
	item_description_dialog.display_actions(action.item)


func clean_up():
	action_dialog.hide()
	entity_dialog.hide()
	inventory_dialog.hide()
	item_action_dialog.hide()
	equipment_dialog.hide()
	equipment_action_dialog.hide()
	item_description_dialog.hide()
	picking_action = false
	picking_item = false


func show_picking_direction() -> void:
	top_bar.display_action("[Pick a direction to interact with]")


func show_aiming() -> void:
	top_bar.display_action("[Pick target location]")


func hide_top_bar() -> void:
	top_bar.hide_action()


func is_busy() -> bool:
	return picking_action || picking_item || aiming


func show_death():
	top_bar.show_death()
