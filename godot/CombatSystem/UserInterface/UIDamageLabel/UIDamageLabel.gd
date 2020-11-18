# Animated label displaying amounts of damage, healing, armor damage, or energy gained.
class_name UIDamageLabel
extends Node2D

enum Types { HEAL, DAMAGE, ARMOR, ENERGY }

const COLOR_TRANSPARENT := Color(1.0, 1.0, 1.0, 0.0)

export var color_damage := Color("#b0305c")
export var color_heal := Color("#3ca370")
export var color_armor := Color("#f2a65e")
export var color_energy := Color("#4da6ff")

var _color: Color setget _set_color
var _amount := 0

onready var _label: Label = $Label
onready var _tween: Tween = $Tween


func setup(type: int, start_global_position: Vector2, amount: int) -> void:
	global_position = start_global_position
	_amount = amount

	match type:
		Types.DAMAGE:
			_set_color(color_damage)
		Types.HEAL:
			_set_color(color_heal)
		Types.ENERGY:
			_set_color(color_energy)
		Types.ARMOR:
			_set_color(color_armor)


func _ready() -> void:
	_label.text = str(_amount)
	_animate()


func _set_color(value: Color) -> void:
	_color = value
	if not is_inside_tree():
		yield(self, "ready")
	_label.modulate = _color


func _animate() -> void:
	var angle := rand_range(-PI / 3.0, PI / 3.0)
	var offset := Vector2.UP.rotated(angle) * 60.0
	_tween.interpolate_property(
		_label,
		"rect_position",
		_label.rect_position,
		_label.rect_position + offset,
		0.4,
		Tween.TRANS_QUAD,
		Tween.EASE_OUT
	)
	_tween.interpolate_property(
		self, "modulate", modulate, COLOR_TRANSPARENT, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN, 0.3
	)
	_tween.start()
	yield(_tween, "tween_all_completed")
	queue_free()
