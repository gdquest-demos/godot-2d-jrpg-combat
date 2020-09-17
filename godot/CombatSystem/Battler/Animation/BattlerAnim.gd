# Hold and plays the base animation for battlers.
tool
class_name BattlerAnim
extends Position2D

signal animation_finished(name)
# Emitted by animations when a combat action should apply its next effect, like dealing damage or healing an ally.
# warning-ignore:unused_signal
signal triggered

enum Direction { LEFT, RIGHT }

# Controls the direction in which the battler looks and moves.
export (Direction) var direction := Direction.RIGHT setget set_direction

var _position_start := Vector2.ZERO

onready var anim_player: AnimationPlayer = $Pivot/AnimationPlayer
onready var anim_player_damage: AnimationPlayer = $Pivot/AnimationPlayerDamage
onready var tween: Tween = $Tween
onready var anchor_front: Position2D = $FrontAnchor
onready var anchor_top: Position2D = $TopAnchor


func _ready() -> void:
	_position_start = position


func play(anim_name: String) -> void:
	if anim_name == "take_damage":
		anim_player_damage.play(anim_name)
		anim_player_damage.seek(0.0)
	else:
		anim_player.play(anim_name)


func is_playing() -> bool:
	return anim_player.is_playing()


func queue_animation(anim_name: String) -> void:
	anim_player.queue(anim_name)
	if not anim_player.is_playing():
		anim_player.play()


func get_front_anchor_global_position() -> Vector2:
	return anchor_front.global_position


func get_top_anchor_global_position() -> Vector2:
	return anchor_top.global_position


func move_forward() -> void:
	tween.interpolate_property(
		self,
		"position",
		position,
		position + Vector2.LEFT * scale.x * 40.0,
		0.3,
		Tween.TRANS_QUART,
		Tween.EASE_IN_OUT
	)
	tween.start()


func move_back() -> void:
	tween.interpolate_property(
		self, "position", position, _position_start, 0.3, Tween.TRANS_QUART, Tween.EASE_IN_OUT
	)
	tween.start()


func set_direction(value: int) -> void:
	direction = value
	scale.x = -1.0 if direction == Direction.RIGHT else 1.0


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	emit_signal("animation_finished", anim_name)
