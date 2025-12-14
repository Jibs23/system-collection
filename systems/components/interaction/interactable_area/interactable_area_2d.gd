@icon("res://systems/components/interaction/interactable_area/icon_interactable_area.png")
extends  Area2D

## Emmited when this area recieves a interaction signal from an interaction area.
signal interacted(source:Node)

## Called when interacted with.
func _on_interact(source:Area2D):
	interacted.emit(source)
	
## Returns true if area can currently be interacted with.
func can_be_interacted() -> bool:
	return monitorable

## Enables or disables the interactable area.
func interaction_toggle(enable:bool):
	set_deferred("monitoring", enable)
