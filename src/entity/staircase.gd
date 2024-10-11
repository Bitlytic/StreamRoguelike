class_name StairEntity
extends Entity


@export_file("*.tscn") var next_level : String


func travel() -> void:
	var scene : PackedScene = load(next_level)
	
	LevelManager.switch_to_level(scene)
