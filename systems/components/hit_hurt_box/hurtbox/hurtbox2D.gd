@icon("res://systems/components/hit_hurt_box/hurtbox/icon_hurt_box2D.png")
## This is a HurtBox, it checks for an delivers damage to overlapping HitBoxes.
extends Area2D

## The group name that Hurtboxes considers valid targets.
static var hitbox_group: String = "HitBox"

@export_category("Target Settings")
## An array of group names that this hurtbox will consider valid targets. If empty, all hitboxes are considered valid.
@export_placeholder("valid groups name") var valid_groups: Array[String] = []

## If true, the valid_groups array is inverted, so that only hitboxes NOT in the valid_groups are considered valid targets.
@export var invert_valid_groups: bool = false

@export_category("HurtBox Settings")
## The amount of damage this hurtbox deals when hitting a valid target.
@export var damage: int = 1

## If true, the hurtbox will automatically attempt to hit valid targets automatically upon overlap.
@export var auto_hit: bool = true

## If true, the hurtbox will disable itself after hitting a valid target.
@export var hit_once: bool = false

## Emmited when this hurtbox hits a valid HitBox.
signal hit(damage: int, from: Node)

## Emmited once a valid target HitBox has entered the HurtBox area.
signal found_valid_target(area: Area2D)

## Emmited once a valid target HitBox has exited the HurtBox area.
signal lost_valid_target(area: Area2D)

func _on_area_entered(area: Area2D) -> void:
	if _is_valid_target(area):
		found_valid_target.emit(area)
		if auto_hit: try_hit(area)

func _on_area_exited(area: Area2D) -> void:
	if _is_valid_target(area):
		lost_valid_target.emit(area)

## Tries to hit the given area if it is a valid target.
func try_hit(area:Area2D) -> void:
	connect("hit", Callable(area, "_on_hit"), ConnectFlags.CONNECT_ONE_SHOT)
	hit.emit(damage, self)
	if hit_once: hitbox_toggle(false)

## Attempts to hit all valid overlapping areas.
func hit_valid_targets() -> void:
	for area in get_valid_targets():
		try_hit(area)

## Returns an array of all HitBoxes currently overlapping this HurtBox.
func get_valid_targets() -> Array:
	var valid_targets: Array = []
	for area in get_overlapping_areas():
		if area.is_in_group(hitbox_group):
			valid_targets.append(area)
	return valid_targets

## Enables or disables this hurtbox.
func hitbox_toggle(enable: bool) -> void:
	set_deferred("monitoring", enable)

## Returns true if this hurtbox's monitoring state is enabled.
func is_hurtbox_enabled() -> bool:
	return monitoring as bool

## Returns true if the given area is a valid target based on the valid_groups and hitbox_group settings.
func _is_valid_target(area: Area2D) -> bool:
	# Is the target a hitbox?
	if !area.is_in_group(hitbox_group):
		return false
	# Has a whitelist been specified?
	if valid_groups.size() == 0:
		return not invert_valid_groups
	# Is the target in a valid group?
	for group_name in valid_groups:
		if area.is_in_group(group_name):
			return not invert_valid_groups
	return invert_valid_groups
