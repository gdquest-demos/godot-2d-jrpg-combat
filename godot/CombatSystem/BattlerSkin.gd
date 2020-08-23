class_name BattlerSkin
extends Position2D

export var TURN_START_MOVE_DISTANCE: float = 40.0
export var TWEEN_DURATION: float = 0.3

onready var tween = $Tween
onready var anim = $AnimationPlayer
var anim_player: AnimationPlayer
onready var position_start: Vector2

var is_blinking: bool = false setget set_is_blinking


func _ready():
	hide()


func move_forward():
	var direction = Vector2(-1.0, 0.0) if owner.party_member else Vector2(1.0, 0.0)
	tween.interpolate_property(
		self,
		'position',
		position_start,
		position_start + TURN_START_MOVE_DISTANCE * direction,
		TWEEN_DURATION,
		Tween.TRANS_QUAD,
		Tween.EASE_OUT
	)
	tween.start()
	yield(tween, "tween_completed")


func move_to(target_position: Vector2):
	tween.interpolate_property(
		self,
		'global_position',
		global_position,
		target_position,
		TWEEN_DURATION,
		Tween.TRANS_QUAD,
		Tween.EASE_OUT
	)
	tween.start()
	yield(tween, "tween_completed")


func return_to_start():
	tween.interpolate_property(
		self, 'position', position, position_start, TWEEN_DURATION, Tween.TRANS_QUAD, Tween.EASE_OUT
	)
	tween.start()
	yield(tween, "tween_completed")


func set_is_blinking(value):
	is_blinking = value
	if is_blinking:
		anim.play("blink")
	else:
		anim.play("idle")


func play_stagger():
	anim_player.play_stagger()


func play_death():
	yield(anim_player.play_death(), "completed")


func appear():
	anim.play("appear")
