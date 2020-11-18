# Represents one energy point. This node has two animations and functions to make it appear and disappear smoothly.
extends TextureRect

const POSITION_SELECTED := Vector2(0.0, -6.0)

onready var _fill: TextureRect = $Fill
onready var _tween: Tween = $Tween

onready var _color_transparent := _fill.modulate


func appear() -> void:
	_tween.interpolate_property(_fill, "modulate", _color_transparent, Color.white, 0.3)
	_tween.start()


func disappear() -> void:
	_tween.interpolate_property(_fill, "modulate", _fill.modulate, _color_transparent, 0.3)
	_tween.start()


func select() -> void:
	_tween.interpolate_property(_fill, "rect_position", Vector2.ZERO, POSITION_SELECTED, 0.2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	_tween.start()


func deselect() -> void:
	_tween.interpolate_property(_fill, "rect_position", POSITION_SELECTED, Vector2.ZERO, 0.2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	_tween.start()
