# Represents a damage-dealing hit to be applied to a target [Battler].
# Encapsulates calculations for how hits are applied based on their properties.
class_name Hit
extends Reference

var _damage := 0
var _target
var _effect: StatusEffect


# Arguments:
# - target: Battler
# - damage: int
func _init(target, damage: int, effect: StatusEffect = null) -> void:
	_target = target
	_damage = damage
	_effect = effect


func apply() -> void:
	if _damage > 0:
		_target.take_damage(_damage)
	if _effect:
		_target.apply_status_effect(_effect)


func calculate_damage() -> int:
	return _damage
