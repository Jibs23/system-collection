@tool
@icon("res://systems/components/health/health_component/icon_heart.png")

## The purpose of this component is to handle health-related functionality, for player characters, npcs or objects.
extends Node

@export_category("Tools")
@export_tool_button("reset health","History") var reset_health_button: Callable = reset_health
@export_tool_button("heal","KeyCall") var heal_button: Callable = func() -> void:
	alter_health(-1)
@export_tool_button("damage","KeyXRotation") var hurt_button: Callable = func() -> void:
	alter_health(1)

@export_category("Health")
## The maximum health of the health component. The current health cannot exceed this value.
@export var max_health: int = 5:
	set(value):
		max_health_set.emit(value)
		return value

## If true, the health component can recover health.
@export var can_heal: bool = true

## If true, the health component cannot take damage.
@export var invincible: bool = false

## The current health of the health component. This variable's setter handles all health-related signals. On _Ready() this will be set to max_health.
@onready var current_health: int = max_health:
	set(new_health):
		if new_health == null:
			push_error(self, " in ",get_parent().name," could not set new_health to ", new_health)
			return current_health
		new_health = clamp(new_health, 0, max_health)

		if new_health == current_health: 
			health_could_not_change.emit(current_health, "no change in health")
			return

		health_changed.emit(new_health)

		if new_health < current_health:
			damaged.emit(current_health - new_health)
		elif new_health > current_health:
			healed.emit(new_health - current_health)
		
		if new_health == max_health:
			health_full.emit()
		elif new_health == 0:
			if Engine.is_editor_hint():
				print("Health component in ", get_parent().name, " has reached 0 health.", " not emitting health_empty signal in editor mode.")
				current_health = new_health
				return
			health_empty.emit()
		
		current_health = new_health

## The current health has been alteretd.
signal health_changed(new_health: int)

## The health could not be changed (e.g. trying to heal at full health).
signal health_could_not_change(current_health: int, reason: String)

## THe maximum health has been set to a new value.
signal max_health_set(new_max_health: int)

## The health is now full.
signal health_full()

## The health is now empty.
signal health_empty()

## The health component has been healed by the specified amount.
signal healed(amount: int)

## The health component has been damaged by the specified amount.
signal damaged(amount: int)

## The health has been reset to max health.
signal health_reset()

## Resets health to max health.
func reset_health() -> void:
	current_health = max_health
	health_reset.emit()

## Alters health by byt amount, positive numbers do dammage and negative do healing.
func alter_health(amount: int) -> void:
	## Return true if the incoming value is meant as healing.
	var healing: bool = amount < 0 
	if healing and not can_heal:
		health_could_not_change.emit(current_health, "cannot heal")
		return
	if not healing and invincible:
		health_could_not_change.emit(current_health, "invincible")
		return
	if healing:
		# HEAL
		current_health += abs(amount)
	else:
		# DAMAGE
		current_health -= abs(amount)

## Sets the maximum health to the specified value. Optionally heals current health to new max health.
func set_max_health(new_max_health: int, heal_current_health: bool = false) -> void:
	max_health = new_max_health
	if heal_current_health:
		reset_health()

## Check whether or not the health component is alive (health > 0).
func is_alive() -> bool:
	return current_health > 0
	
## Called when a damage or heal value is recieved from an external source. Negative values are considered healing.
func _on_value_recieved(value: int, _source: Node = null) -> void:
	alter_health(value)