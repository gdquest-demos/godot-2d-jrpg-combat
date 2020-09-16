# Deals damage periodically
class_name StatusEffectBug
extends StatusEffect

var damage := 3


# data: StatusEffectData
func _init(target, data).(target, data) -> void:
	id = "bug"
	damage = data.ticking_damage
	_can_stack = true


func _apply() -> void:
	_target.take_hit(Hit.new(damage))
