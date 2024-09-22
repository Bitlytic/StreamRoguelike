class_name TopBar
extends Control


@onready var player_stats_panel: PanelContainer = $PlayerStats
# TODO: Maybe refactor this to have a function in the parent
@onready var hp_label: Label = player_stats_panel.find_child("HPLabel")
@onready var information_panel : PanelContainer = $Information
@onready var info_label: Label = information_panel.find_child("InfoLabel")



var health : int
var max_health : int

var health_format := "HP: %d/%d"


func _ready():
	PlayerEventBus.health_changed.connect(on_player_health_changed)


func on_player_health_changed(player: Player) -> void:
	health = player.health
	max_health = player.max_health
	
	_update_label()


func _update_label() -> void:
	hp_label.text = health_format % [health, max_health]


func display_action(action: String) -> void:
	info_label.text = action
	information_panel.show()
	player_stats_panel.hide()


func hide_action() -> void:
	player_stats_panel.show()
	information_panel.hide()
