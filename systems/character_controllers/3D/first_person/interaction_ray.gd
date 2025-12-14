extends RayCast3D

## The group which the interaction box will consider to be interactable.
static var interactable_group: StringName = "interactable"

signal interact(source:Node,target:Node)
signal found_interactable(object:Object)
signal lost_interactable(object:Object)

var focused_object:Object = null:
	set(new):
		if new == null and focused_object != null:
			lost_interactable.emit(focused_object)
		elif new != null and focused_object == null:
			found_interactable.emit(new)
		
		focused_object = new

func _physics_process(_delta: float) -> void:
	if is_colliding() and _is_object_interactable(get_collider()) and get_collider() != focused_object: 
		focused_object = get_collider()
	if !is_colliding() and focused_object != null:
		focused_object = null

## Triggers an interaction in overlapping objects in the valid groups.
func try_interaction(object:Object) -> void:
	if not enabled: return
	if _is_object_interactable(object):
		connect("interact", Callable(object, "_on_interact"), ConnectFlags.CONNECT_ONE_SHOT)
		interact.emit(self,object)

func _on_object_found(object: Object) -> void:
	if _is_object_interactable(object):
		found_interactable.emit(object)

func _on_object_lost(object: Object) -> void:
	if _is_object_interactable(object):
		lost_interactable.emit(object)

## Returns true if the 'object' is in the apporpriate interact group.
func _is_object_interactable(object:Object) -> bool:
	return true if object and object.is_in_group(interactable_group) and is_colliding() else false

## Enables or disables the interaction box.
func interact_toggle(enable:bool):
	set_deferred("monitoring", enable)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fps_interact"): try_interaction(focused_object)
