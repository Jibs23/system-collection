@tool
@icon("res://systems/components/collectible/icon_collectable.png")
extends Area2D

## What category this collectable belongs to.
enum CollectableCategory {
	## A limited collectible, of which there is a set amount in the game world.
	COLLECTABLE,
	## A health pickup that restores health.
	HEALTH,
	## An item that can be picked up, and added to the player's inventory.
	ITEM
}
## The different types of collectables available in the game.
enum CollectableType {
}

@export var collectable_category: CollectableCategory

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		collect()

func collect() -> void:
	queue_free()

func _init() -> void:
	if Engine.is_editor_hint():
		set_collision_layer(128) # Layer 8: Collectables
		set_collision_mask(256) # masks Layer 9: Characters