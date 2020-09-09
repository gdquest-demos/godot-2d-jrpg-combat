# Represents and applies the effect of a given status to a battler.
# The status takes effect once added to the scene tree.
# @tags: virtual
class_name StatusEffect
extends Node

var _target: Battler

# Provided by the ActiveTurnQueue.
var time_scale := 1.0
var duration_seconds := 0.0 setget set_duration_seconds
var is_ticking := false
var ticking_interval := 1.0

var _time_left: float = -INF
var _ticking_clock := 0.0


func _init(target: Battler, duration: float) -> void:
	_target = target
	set_duration_seconds(duration)
	if is_ticking:
		_ticking_clock = ticking_interval


func _ready() -> void:
	_start()


func _process(delta: float) -> void:
	_time_left -= delta * time_scale

	if is_ticking:
		var old_clock = _ticking_clock
		_ticking_clock = wrapf(_ticking_clock - delta * time_scale, 0.0, 1.0)
		if _ticking_clock > old_clock:
			_apply()

	if _time_left < 0.0:
		_expire()


# Initializes the status effect on the battler.
# @tags: virtual
func _start() -> void:
	pass


# Applies the status effect to the battler.
# @tags: virtual
func _apply() -> void:
	pass


# Cleans up and removes the status effect to the battler.
# @tags: virtual
func _expire() -> void:
	set_process(false)
	queue_free()


func set_duration_seconds(value: float) -> void:
	duration_seconds = value
	_time_left = duration_seconds
	set_process(true)
