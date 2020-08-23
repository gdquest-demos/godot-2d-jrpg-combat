extends Resource
class_name Stats

signal health_depleted

export var max_health := 100.0

var attack := 10.0
var speed := 35.0

var health := max_health setget set_health


func set_health(value: float) -> void:
	health = clamp(value, 0.0, max_health)
	if is_equal_approx(health, 0.0):
		emit_signal("health_depleted")
