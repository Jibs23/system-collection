extends State

@export var walk: State

func enter() -> void:
	pass

func exit() -> void:
	pass
	
func process_update(_delta: float) -> void:
	if !actor: return
	if actor.input_dir != Vector2.ZERO: transition.emit(walk,self)

func physics_update(_delta: float) -> void:
	pass
