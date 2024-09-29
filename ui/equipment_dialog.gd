class_name EquipmentDialog
extends ListDialog


signal equipment_selected(result: Item)

var equipment_properties : Array[String] = [
	"ranged_weapon",
	"weapon",
	"helmet",
	"chestplate",
	"boots"
]


func _physics_process(delta: float) -> void:
	if !visible:
		return
	poll_input()


func display_items(equipment: Equipment) -> void:
	clear_options()
	
	for property: String in equipment_properties:
		var item : Item = equipment.get(property) 
		if item:
			create_button(item.item_name, item)
	
	if action_buttons.size() <= 0:
		equipment_selected.emit(null)
		return
	
	connect_options(on_item_selected)
	
	_change_focus(0)
	
	show()


func on_item_selected(result: Object) -> void:
	
	if result is Item:
		equipment_selected.emit(result)
		hide()
