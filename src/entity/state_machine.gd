class_name StateMachine
extends Node

@export var initial_state : State


var current_state : State
var states : Dictionary = {}


func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transition)
	
	if initial_state:
		_enter_state(initial_state)


func do_process() -> EntityAction:
	if current_state:
		return current_state.do_process()
	return EntityAction.new()


func on_child_transition(state: State, new_state_name: String) -> void:
	if state != current_state:
		return
	
	var new_state : State = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	_enter_state(new_state)


func _enter_state(state: State):
	if current_state:
		current_state.exit()
	
	current_state = state
	state.enter()
