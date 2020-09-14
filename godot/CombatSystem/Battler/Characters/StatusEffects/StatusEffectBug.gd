# Deals damage periodically
class_name StatusEffectBug
extends StatusEffect

var damage := 3


func _init(target, data: StatusEffectData).(target, data) -> void:
	damage = data.ticking_damage


func _apply() -> void:
	_target.take_damage(damage)
