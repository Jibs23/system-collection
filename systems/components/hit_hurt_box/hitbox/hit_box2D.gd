@icon("res://systems/components/hit_hurt_box/hitbox/icon_hit_box2D.png")
## This script defines a HitBox, an Area2D that recieves scans for hurtboxes. Usually this is connected to a health component to apply damage.
extends Area2D
static var hurtbox_group: String = "HurtBox"

## Emmited when this hitbox is hit by a valid hurtbox.
signal hit(damage: int, from: Node)

func _on_hit(damage: int, from: Node) -> void:
	hit.emit(damage, from)
	print_debug(self, " in ", get_parent().name, " was hit by ", from.name, " for ", damage, " damage.")

## Enables or disables this hitbox's monitoring state.
func hitbox_toggle(enable: bool) -> void:
	set_deferred("monitorable", enable)

## Returns true if this hitbox monitorable is enabled.
func is_hitbox_enabled() -> bool:
	return monitorable as bool
