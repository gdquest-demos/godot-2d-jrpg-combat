extends TextureProgress

# Rate of the animation relative to `max_value`. A value of 1.0 means the animation fills 
# the entire bar once in one second.
export var fill_rate := 1.0

var target_value := 0.0 setget set_target_value

onready var tween: Tween = $Tween


func set_target_value(amount: float) -> void:
	target_value = amount
	var duration := abs(target_value - value) / max_value * fill_rate
	tween.interpolate_property(self, "value", value, target_value, duration, Tween.TRANS_QUAD)
	if tween.is_active():
		tween.stop_all()
	tween.start()
