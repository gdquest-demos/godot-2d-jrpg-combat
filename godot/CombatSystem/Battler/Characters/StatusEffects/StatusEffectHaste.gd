class_name StatusEffectHaste
extends StatusEffect

var haste_rate := 0.4

var _stat_modifier_id := -1


func _init(target: Battler, duration: float, _haste_rate: float).(target, duration) -> void:
	haste_rate = _haste_rate


func _start() -> void:
	_stat_modifier_id = _target.stats.add_modifier("speed", -1.0 * _target.stats.speed * haste_rate)


func _expire() -> void:
	_target.stats.remove_modifier("speed", _stat_modifier_id)
	queue_free()
