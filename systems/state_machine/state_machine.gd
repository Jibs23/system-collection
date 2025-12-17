@icon("res://systems/state_machine/icon_state_machine.png")
extends Node

@export var initial_state: State

signal state_entered(new_state: State)
signal state_exited(old_state: State)

@onready var actor: Node2D = get_parent()
@onready var current_state: State = initial_state:
	set(new_state):
		if current_state:
			current_state.exit()
			state_exited.emit(current_state)
		current_state = new_state
		new_state.enter()
		state_entered.emit(new_state)

func _ready() -> void:
	_connect_states()

func _connect_states() -> void:
	for state in get_children():
		state.connect("transition", Callable(self, "_on_state_transition"))
		state.state_machine = self
		state.actor = actor

func _process(delta: float) -> void:
	if current_state: current_state.process_update(delta)

func _physics_process(delta: float) -> void:
	if current_state: current_state.physics_update(delta)
	
## Checks if the transition is valid, returns a bool.
func _is_transition_valid(to_state: State, from_state: State) -> bool:
	var output:bool = true
	
	if from_state != current_state:
		push_error("State '%s' tried to transition but is not the current from_state in FSM '%s'" % [from_state.name, name])
		output = false
		
	if !to_state:
		push_error("State '%s' not found in FSM '%s'" % [to_state, name])
		output = false
		
	if to_state.state_ready == false:
		push_error("State '%s' is not ready to be entered in FSM '%s'" % [to_state, name])
		output = false
		
	if to_state == current_state:
		push_error("WARNING: %s is the same as %s" % [to_state, from_state])
		output = false
	
	return output

## Handles state transitions.
func _on_state_transition(to_state: State, from_state: State ) -> void:
	if !_is_transition_valid(to_state,from_state): return
	current_state = to_state
	
func _on_actor_input(input:Variant) -> void:
	pass
