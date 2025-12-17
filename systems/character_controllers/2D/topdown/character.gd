## Used for 2D characters.
extends CharacterBody2D

var input_dir: Vector2 = Vector2.ZERO
var input_action: Variant

@export var facing_direction: Vector2 = Vector2.DOWN:
	set(dir):
		if dir == Vector2.ZERO:
			return
		if dir != facing_direction and dir != Vector2.ZERO:
			facing_direction_changed.emit(dir)
		facing_direction = dir
@export var sprite_sheet: Sprite2D
@export var collide_box: CollisionShape2D 
@export var animation_player: AnimationPlayer
@export var state_machine: StateMachine
	
signal facing_direction_changed(new_direction: Vector2)

enum TurnDirection { AROUND, LEFT, RIGHT }

func turn(direction: TurnDirection) -> void:
	match direction:
		TurnDirection.AROUND:
			facing_direction = -facing_direction
		TurnDirection.LEFT:
			facing_direction = Vector2(-facing_direction.y, facing_direction.x)
		TurnDirection.RIGHT:
			facing_direction = Vector2(facing_direction.y, -facing_direction.x)

func die() -> void:
	print(name, " has died.")
	queue_free()

## The last emitted direction, to account for Vector2.ZERO deadzone.
var last_dir: Vector2 = Vector2.ZERO

## Signals the direction input, and accounts for Vector2.ZERO deadzone.
func signal_dir(dir: Vector2) -> void:
	if last_dir == dir and dir == Vector2.ZERO:
		return
	last_dir = dir
	input_dir.emit(dir)
