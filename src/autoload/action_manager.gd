extends Node


signal action_picked(action: EntityAction)

@onready var action_dialog: Control = $UI/ActionDialog


var picking_action := false
var target_position : Vector2i

func _ready():
	action_dialog.action_selected.connect(on_action_selected)


func _physics_process(delta: float) -> void:
	if picking_action && Input.is_action_just_pressed("cancel"):
		on_action_selected(EntityAction.new(ActionType.NONE))

func show_dialog(cell: GridCell, target_position: Vector2i):
	self.target_position = target_position
	action_dialog.display_actions(cell)
	picking_action = true


func on_action_selected(action: EntityAction):
	action.position = target_position
	action_picked.emit(action)
	action_dialog.hide()
	picking_action = false
