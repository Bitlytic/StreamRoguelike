class_name Effect
extends Node2D


var target : Entity
var turns_left := 5


func _init(target: Entity, turns: int = 1):
	self.target = target
	self.turns_left = turns


func tick_effect() -> void:
	turns_left -= 1
	
	if turns_left <= 0:
		queue_free()
		return
