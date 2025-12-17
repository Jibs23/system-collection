extends State


@export_range(1,100,.5) var speed:float = 1

func enter() -> void:
	pass

func exit() -> void:
	pass

func process_update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	if !actor: return
	if actor.input_dir == Vector2.ZERO: transition.emit(state_idle, self)
	walk(actor.input_dir)
	
func walk(dir:Vector2) -> void:
	actor.velocity += dir * speed
