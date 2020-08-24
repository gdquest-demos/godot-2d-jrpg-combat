class_name SelectBattlerArrow
extends Node2D

signal target_selected(battler)

onready var anim_player = $Sprite/AnimationPlayer
onready var tween = $Tween

export var MOVE_DURATION: float = 0.1

var targets: Array
var target_current: Battler setget set_target_current


func _init() -> void:
	set_as_toplevel(true)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		emit_signal("target_selected", [target_current])
	elif event.is_action_pressed("ui_cancel"):
		emit_signal("target_selected", [])

	var new_target: Battler
	var direction := Vector2.ZERO
	if event.is_action_pressed("ui_left"):
		direction = Vector2.LEFT
	elif event.is_action_pressed("ui_up"):
		direction = Vector2.UP
	elif event.is_action_pressed("ui_right"):
		direction = Vector2.RIGHT
	elif event.is_action_pressed("ui_down"):
		direction = Vector2.DOWN

	if direction != Vector2.ZERO:
		new_target = find_closest_target(direction)
		if new_target:
			set_target_current(new_target)


func setup(battlers: Array) -> void:
	show()
	targets = battlers
	target_current = targets[0]
	scale.x = 1.0 if target_current.is_party_member else -1.0
	global_position = target_current.get_anchor_global_position()
	anim_player.play("wiggle")


func move_to(target_position: Vector2):
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(
		self,
		'position',
		position,
		target_position,
		MOVE_DURATION,
		Tween.TRANS_CUBIC,
		Tween.EASE_OUT
	)
	tween.start()


# Returns the closest target in the given direction.
# Returns null if there is no other target in the direction.
func find_closest_target(direction: Vector2) -> Battler:
	var selected_target: Battler
	var distance_to_selected: float = 100000.0

	var candidates := []
	for battler in targets:
		if battler == target_current:
			continue
		var to_battler: Vector2 = battler.global_position - position
		if abs(direction.angle_to(to_battler)) < PI / 3.0:
			candidates.append(battler)

	for battler in candidates:
		var distance := position.distance_to(battler.global_position)
		if distance < distance_to_selected:
			selected_target = battler
			distance_to_selected = distance

	return selected_target


func set_target_current(value: Battler) -> void:
	target_current = value
	move_to(target_current.get_anchor_global_position())
