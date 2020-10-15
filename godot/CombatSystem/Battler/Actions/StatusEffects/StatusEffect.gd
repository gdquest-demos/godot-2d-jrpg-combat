# Represents and applies the effect of a given status to a battler.
# The status takes effect as soon as the node is added to the scene tree.
# @tags: virtual
class_name StatusEffect
extends Node

var _target

# Provided by the ActiveTurnQueue.
var time_scale := 1.0
var duration_seconds := 0.0 setget set_duration_seconds
var is_ticking := false
var ticking_interval := 1.0
var is_active := true setget set_is_active

var id := "base_effect"

var _time_left: float = -INF
var _ticking_clock := 0.0
var _can_stack := false


# target: Battler
# data: StatusEffectData
func _init(target, data) -> void:
	_target = target
	set_duration_seconds(data.duration_seconds)

	is_ticking = data.is_ticking
	ticking_interval = data.ticking_interval
	_ticking_clock = ticking_interval


func _ready() -> void:
	_start()


func _process(delta: float) -> void:
	_time_left -= delta * time_scale

	if is_ticking:
		var old_clock = _ticking_clock
		_ticking_clock = wrapf(_ticking_clock - delta * time_scale, 0.0, ticking_interval)
		if _ticking_clock > old_clock:
			_apply()

	if _time_left < 0.0:
		set_process(false)
		_expire()


func can_stack() -> bool:
	return _can_stack


func get_time_left() -> float:
	return _time_left


func expire() -> void:
	_expire()


func set_is_active(value) -> void:
	is_active = value
	set_process(is_active)


# Initializes the status effect on the battler.
# @tags: virtual
func _start() -> void:
	pass


# Applies the status effect to the battler. Used with ticking effects,
# for example, a poison status dealing damage every two seconds.
# @tags: virtual
func _apply() -> void:
	pass


# Cleans up and removes the status effect from the battler.
# @tags: virtual
func _expire() -> void:
	queue_free()


func set_duration_seconds(value: float) -> void:
	duration_seconds = value
	_time_left = duration_seconds
