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


var health : int
var max_health : int

var health_format := "HP: %d/%d"


func _ready():
	PlayerEventBus.health_changed.connect(on_player_health_changed)
	PlayerEventBus.floor_changed.connect(on_player_floor_changed)
	PlayerEventBus.weight_changed.connect(on_player_weight_changed)


func on_player_health_changed(player: Player) -> void:
	health = player.health
	max_health = player.max_health
	
	_update_label()


func on_player_floor_changed() -> void:
	floor_label.text = "FLOOR: %d" % [LevelManager.current_level+1]


func on_player_weight_changed(player: Player) -> void:
	weight_label.text = "WEIGHT: %d / %d" % [player.get_weight(), player.get_max_weight()]


func _update_label() -> void:
	hp_label.text = health_format % [health, max_health]


func display_action(action: String) -> void:
	info_label.text = action
	information_panel.show()
	player_stats_panel.hide()
	weight_stats.hide()
	floor_num.hide()


func hide_action() -> void:
	player_stats_panel.show()
	floor_num.show()
	weight_stats.show()
	information_panel.hide()
