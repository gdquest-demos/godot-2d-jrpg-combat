# Stores and manages the battler's base stats like health, energy, and base damage.
extends Resource
class_name BattlerStats

signal health_depleted
signal health_changed(old_value, new_value)
signal energy_changed(old_value, new_value)

export var max_health := 100.0
export var max_energy := 6

export var attack := 10.0
export var speed := 70.0

var health := max_health setget set_health
var energy := 0 setget set_energy


func set_health(value: float) -> void:
	var health_previous := health
	health = clamp(value, 0.0, max_health)
	emit_signal("health_changed", health_previous, health)
	if is_equal_approx(health, 0.0):
		emit_signal("health_depleted")


func set_energy(value: int) -> void:
	var energy_previous := energy
	energy = int(clamp(value, 0.0, max_energy))
	emit_signal("energy_changed", energy_previous, energy)
