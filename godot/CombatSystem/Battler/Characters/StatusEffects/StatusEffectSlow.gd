class_name StatusEffectSlow
extends StatusEffect

var slow_rate := 0.4

var _stat_modifier_id := -1


func _init(target: Battler, duration: float, _slow_rate: float).(target, duration) -> void:
	slow_rate = _slow_rate


func _start() -> void:
	_stat_modifier_id = _target.stats.add_modifier("speed", -1.0 * _target.stats.speed * slow_rate)


func _expire() -> void:
	_target.stats.remove_modifier("speed", _stat_modifier_id)
	queue_free()
