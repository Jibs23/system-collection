@icon("res://systems/components/interaction/interaction_box/icon_interaction_box2D.png")
extends Area2D

## The group which the interaction box will consider to be interactable.
static var interactable_group: StringName = "interactable"

signal interact(source:Node)
signal found_interactable(area:Area2D)
signal lost_interactable(area:Area2D)

@export var valid_groups: Array[String] = []

## Triggers an interaction in overlapping areas in the valid groups.
func try_interaction() -> void:
	if not can_interact(): return
	if get_overlapping_areas() == null: return
	for area in get_overlapping_areas():
		if _is_area_interactable(area):
			connect("interact", Callable(area, "_on_interact"), ConnectFlags.CONNECT_ONE_SHOT)
			interact.emit(self)

## Returns true if area can currently interact.
func can_interact() -> bool:
	return monitoring
	
func _on_area_entered(area: Area2D) -> void:
	if _is_area_interactable(area):
		found_interactable.emit(area)

func _on_area_exited(area: Area2D) -> void:
	if _is_area_interactable(area):
		lost_interactable.emit(area)

## Returns true if the 'area' is in the apporpriate interact group.
func _is_area_interactable(area:Area2D) -> bool:
	return true if area.is_in_group(interactable_group) else false

## Enables or disables the interaction box.
func interact_toggle(enable:bool):
	set_deferred("monitoring", enable)
