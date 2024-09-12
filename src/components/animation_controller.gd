class_name AnimationController
extends Node


@export var animation_player : AnimationPlayer


func play_attack_animation(direction: int):
	
	var dir_string := Direction.direction_to_string(direction)
	
	var anim_name := "attack_" + dir_string
	
	animation_player.stop()
	animation_player.play(anim_name, -1, 3.0)
	
