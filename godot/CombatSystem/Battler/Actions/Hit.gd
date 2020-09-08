# Represents a damage-dealing hit to be applied to a target [Battler].
# Encapsulates calculations for how hits are applied based on their properties.
class_name Hit
extends Reference

var _damage := 0
var _target: Battler


func _init(target: Battler, damage: int) -> void:
	_target = target
	_damage = damage


func apply() -> void:
	_target.take_damage(_damage)


func calculate_damage() -> int:
	return _damage
