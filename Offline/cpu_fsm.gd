# FSM.gd
extends Node

@export var starting_state: State
@export var current_state: State

func init(parent: CPU) -> void:
	var ball = parent.ball
	var enemy = parent.enemy
	var wall = parent.wall
	var charge_time = parent.charge_time
	for child in get_children():
		if child is State:
			child.parent = parent
			child.ball = ball
			child.enemy = enemy
			child.wall = wall
			child.charge_time = charge_time
		else:
			push_warning("Child %s does not extend State!" % child.name)
		
	if starting_state and starting_state is State:
		change_state(starting_state)
	else:
		push_error("Starting state is not set correctly!")

func change_state(new_state: State) -> void:
	if current_state and current_state is State:
		current_state.exit()
	current_state = new_state
	if current_state and current_state is State:
		current_state.enter()
	else:
		push_error("New state does not extend State!")

func process_physics(delta: float) -> void:
	if current_state and current_state is State:
		var new_state = current_state.process_physics(delta)
		if new_state:
			change_state(new_state)

func process_frame(delta: float) -> void:
	if current_state and current_state is State:
		var new_state = current_state.process_frame(delta)
		if new_state:
			change_state(new_state)
