class_name GeneratedItemEntity
extends Entity


@export var influence : int = 0

const item_entity = preload("res://src/entity/item/item_entity.tscn")


func _ready():
	# TODO: Generate more than just weapons
	var weapon : Item = LootGenerationUtil.generate_weapon(influence)
	
	var spawned_item_entity := item_entity.instantiate()
	
	spawned_item_entity.item = weapon
	spawned_item_entity.count = 1
	
	spawned_item_entity.grid_position = grid_position
	
	get_tree().current_scene.add_child(spawned_item_entity)
	
