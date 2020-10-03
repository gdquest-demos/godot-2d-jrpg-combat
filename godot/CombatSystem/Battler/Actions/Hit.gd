# Represents a damage-dealing hit to be applied to a target [Battler].
# Encapsulates calculations for how hits are applied based on their properties.
class_name Hit
extends Reference

var damage := 0
var hit_chance: float
var effect: StatusEffect


func _init(_damage: int, _hit_chance := 100.0, _effect: StatusEffect = null) -> void:
	damage = _damage
	hit_chance = _hit_chance
	effect = _effect


func does_hit() -> bool:
	return randf() * 100.0 < hit_chance
