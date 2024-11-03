class_name TopBar
extends Control


@onready var player_stats_panel: PanelContainer = $PlayerStats
# TODO: Maybe refactor this to have a function in the parent
@onready var hp_label: Label = player_stats_panel.find_child("HPLabel")
@onready var information_panel : PanelContainer = $Information
@onready var info_label: Label = information_panel.find_child("InfoLabel")
@onready var floor_num: PanelContainer = $FloorNum
@onready var floor_label: Label = $FloorNum/FloorLabel
@onready var weight_stats: PanelContainer = $WeightStats
@onready var weight_label: Label = $WeightStats/WeightLabel
@onready var death_stats: PanelContainer = $DeathStats
@onready var death_label: Label = $DeathStats/DeathLabel
@onready var key_display: PanelContainer = $KeyDisplay
@onready var key_label: Label = $KeyDisplay/KeyLabel


var health : int
var max_health : int

var health_format := "HP: %d/%d"

var key_count := 0


func _ready():
	PlayerEventBus.health_changed.connect(on_player_health_changed)
	PlayerEventBus.floor_changed.connect(on_player_floor_changed)
	PlayerEventBus.weight_changed.connect(on_player_weight_changed)
	PlayerEventBus.keys_changed.connect(on_player_keys_changed)


func on_player_health_changed(player: Player) -> void:
	health = player.health
	max_health = player.max_health
	
	_update_label()


func on_player_floor_changed() -> void:
	floor_label.text = "FLOOR: %d" % [LevelManager.current_level+1]


func on_player_weight_changed(player: Player) -> void:
	weight_label.text = "WEIGHT: %d / %d" % [player.get_weight(), player.get_max_weight()]


func on_player_keys_changed(player: Player) -> void:
	var slot := player.inventory.find_item_slot(ItemRegistry.KEY)
	
	if slot:
		key_count = slot.count
		show_keys()
	else:
		key_count = 0
		key_display.hide()


func _update_label() -> void:
	hp_label.text = health_format % [health, max_health]


func display_action(action: String) -> void:
	info_label.text = action
	information_panel.show()
	player_stats_panel.hide()
	weight_stats.hide()
	floor_num.hide()
	key_display.hide()


func hide_action() -> void:
	player_stats_panel.show()
	floor_num.show()
	weight_stats.show()
	information_panel.hide()
	show_keys()


func show_death() -> void:
	player_stats_panel.hide()
	floor_num.hide()
	weight_stats.hide()
	information_panel.hide()
	
	death_stats.show()
	death_label.text = "Final Floor: %d Turns taken: %d Enemies Killed: %d" % [LevelManager.current_level + 1, LevelManager.total_turns, GridWorld.enemies_killed]


func show_keys():
	if key_count:
		key_display.show()
		key_label.text = "Keys: %d" % [key_count]
