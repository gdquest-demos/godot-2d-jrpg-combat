# Animated life bar.
extends TextureProgress

# Rate of the animation relative to `max_value`. A value of 1.0 means the animation fills 
# the entire bar once in one second.
export var fill_rate := 1.0

# When this value changes, the bar smoothly animates towards that value using a tween.
var target_value := 0.0 setget set_target_value

onready var _tween: Tween = $Tween
onready var _anim_player: AnimationPlayer = $AnimationPlayer


func setup(health: float, max_health: float) -> void:
	max_value = max_health
	value = health
	target_value = health
	_tween.connect("tween_completed", self, "_on_Tween_tween_completed")


func set_target_value(amount: float) -> void:
	if target_value > amount:
		_anim_player.play("damage")

	target_value = amount
	if _tween.is_active():
		_tween.stop_all()
	var duration := abs(target_value - value) / max_value * fill_rate
	_tween.interpolate_property(self, "value", value, target_value, duration, Tween.TRANS_QUAD)
	_tween.start()


func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	if value < 0.2 * max_value:
		_anim_player.play("danger")
