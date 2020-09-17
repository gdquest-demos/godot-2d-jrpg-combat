# Animated life bar.
extends TextureProgress

# Rate of the animation relative to `max_value`. A value of 1.0 means the animation fills 
# the entire bar once in one second.
export var fill_rate := 1.0

# When this value changes, the bar smoothly animates towards that value using a tween.
var target_value := 0.0 setget set_target_value

onready var tween: Tween = $Tween
onready var anim_player: AnimationPlayer = $AnimationPlayer


func set_target_value(amount: float) -> void:
	if target_value > amount:
		anim_player.play("damage")

	target_value = amount
	if tween.is_active():
		tween.stop_all()
	var duration := abs(target_value - value) / max_value * fill_rate
	tween.interpolate_property(self, "value", value, target_value, duration, Tween.TRANS_QUAD)
	tween.start()
