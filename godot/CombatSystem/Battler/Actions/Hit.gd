class_name Hit
extends Object

var damage := 0
var target: Battler = null


func _init(_target: Battler, _damage: int) -> void:
	target = _target
	damage = _damage


func apply() -> void:
	target.take_damage(damage)
