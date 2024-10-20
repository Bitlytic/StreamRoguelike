@tool
class_name Entity
extends Node2D


signal health_changed(new_health: int)
signal died(entity: Entity)


const SPRITE_OFFSET := Vector2(8, 0)

@export var entity_name : String = ""

@export_group("Entity Stats")
@export var max_health : int = 10
@onready var health : int = max_health

@export var max_weight := 10.0
@export var equipment := Equipment.new()

@export_group("Entity Info")
@export var is_character := false

@export var blocks_vision := false
@export var blocks_movement := false

@export_group("Vision Colors")
@export var discovered_color := Color("#434343")
@export var vision_color := Color("#FFFFFF")


var player: Player:
	get():
		if !player:
			player = get_tree().get_first_node_in_group("player")
		return player


var discovered := false
var in_vision := false :
	set(val):
		in_vision = val
		on_vision_changed()

var processed_this_frame := false

var inventory := Inventory.new()

var cell_size := Vector2(16, 16)

var effects_holder : Node

var grid_position : Vector2i : 
	set(val):
		grid_position = val
		_update_render_position()

var stunned := false
var vulnerable := false
var weak := false

func _ready():
	if !Engine.is_editor_hint():
		grid_position = global_position / GridWorld.cell_size.floor()
		
		GridWorld.add_entity(self)
		name = get_entity_name()
		
		effects_holder = Node.new()
		add_child(effects_holder)


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		global_position = (global_position / GridWorld.cell_size).floor() * GridWorld.cell_size + Vector2(8, 8)


func do_process() -> EntityAction:
	tick_effects()
	return EntityAction.new()


func _update_render_position() -> void:
	global_position = Vector2(grid_position)*cell_size + (cell_size / 2.0)


func process_attack(attack: Attack) -> void:
	_take_damage(attack.damage)
	
	attack.target = self
	
	for effect in attack.effects:
		effect.apply_effect(self)
	
	if attack.attacker && attack.attacker != self:
		for effect: OnHitEffect in attack.on_hit_effects:
			effect.perform_effect(attack)
		
		for effect: OnHitEffect in equipment.get_on_hit_effects():
			effect.perform_effect(attack)
	
	MessageManager.add_message(grid_position, Message.from_attack(attack))


func _take_damage(damage: int) -> void:
	health -= damage
	if health <= 0:
		health = 0
		died.emit(self)
		queue_free()
		Vector2(0, 0) * Vector2(1, 1)
	else:
		health_changed.emit(health)


func heal(amount: int) -> void:
	var message := Message.new()
	message.color = BityColors.SHAMROCK
	message.text = str(amount)
	
	MessageManager.add_message(grid_position, message)
	
	health += amount
	if health > max_health:
		health = max_health
	
	health_changed.emit(health)


func is_passable(e: Entity) -> bool:
	return !blocks_movement


func can_see_through(e: Entity) -> bool:
	return !blocks_vision


func get_entity_name() -> String:
	if entity_name:
		return entity_name
	return "<NULL>"


func on_vision_changed() -> void:
	if in_vision:
		discovered = true
		modulate = vision_color
	else:
		if discovered && !is_character:
			modulate = discovered_color
		else:
			modulate = Color(0, 0, 0, 0)


func get_description() -> String:
	return "Uninitializated Description"


func get_weight() -> float:
	return equipment.get_weight() + inventory.get_weight()


func get_max_weight() -> float:
	return max_weight


func get_effects() -> Array[Effect]:
	var effects : Array[Effect]
	
	for c in effects_holder.get_children():
		if c is Effect:
			effects.append(c)
	
	return effects


func tick_effects() -> void:
	for c in effects_holder.get_children():
		if c is Effect:
			c.tick_effect()


func reset_modifiers():
	stunned = false
	vulnerable = false
	weak = false
