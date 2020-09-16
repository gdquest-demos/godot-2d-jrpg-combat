# Represents a damage-dealing hit to be applied to a target [Battler].
# Encapsulates calculations for how hits are applied based on their properties.
class_name Hit
extends Reference

var _damage := 0
var _target
var _effect: StatusEffect
var _hit_chance: float


# Arguments:
# - target: Battler
# - damage: int
func _init(target, damage: int, effect: StatusEffect = null, hit_chance := 100.0) -> void:
	_target = target
	_damage = damage
	_effect = effect
	_hit_chance = hit_chance


func does_hit() -> bool:
	return randf() * 100.0 < _hit_chance


func apply() -> void:
	if _damage > 0:
		_target.take_damage(_damage)
	if _effect:
		_target.apply_status_effect(_effect)


func calculate_damage() -> int:
	return _damage
