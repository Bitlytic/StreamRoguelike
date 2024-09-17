class_name State
extends Node


signal transitioned(state: State, new_state_name: String)

func enter() -> void:
	pass


func exit() -> void:
	pass


func do_process() -> EntityAction:
	return EntityAction.new()
