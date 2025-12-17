@icon("res://systems/state_machine/states/icon_state.png")
class_name State extends Node

## Whether the state is ready to be entered.
var state_ready: bool = true

var state_machine: Node
var actor: Node

## The path to the idle state node, for transitions. Becomes a string when called.
@export var state_idle: State

## Emitted to transition to another state.
@warning_ignore("unused_signal")
signal transition(to_state: State, from_state: State)

## Called after entering the state.
func enter() -> void:
	pass

## Called before exiting the state.
func exit() -> void:
	pass

## Used in _process, to be called every frame.
func process_update(_delta: float) -> void:
	pass

## Used in _physics_process, to be called every physics frame.
func physics_update(_delta: float) -> void:
	pass
