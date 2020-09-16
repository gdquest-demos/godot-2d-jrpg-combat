# Represents one energy point. This node has two animations and functions to make it appear and disappear smoothly.
extends TextureRect

const POSITION_SELECTED := Vector2(0.0, -6.0)

onready var fill: TextureRect = $Fill
onready var tween: Tween = $Tween

onready var _color_transparent := fill.modulate


func appear() -> void:
	tween.interpolate_property(fill, "modulate", _color_transparent, Color.white, 0.3)
	tween.start()


func disappear() -> void:
	tween.interpolate_property(fill, "modulate", fill.modulate, _color_transparent, 0.3)
	tween.start()


func select() -> void:
	tween.interpolate_property(fill, "rect_position", Vector2.ZERO, POSITION_SELECTED, 0.2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()


func deselect() -> void:
	tween.interpolate_property(fill, "rect_position", POSITION_SELECTED, Vector2.ZERO, 0.2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
