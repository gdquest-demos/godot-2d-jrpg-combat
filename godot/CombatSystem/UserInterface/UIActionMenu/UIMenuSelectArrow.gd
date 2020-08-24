extends Sprite

onready var tween: Tween = $Tween

func move_to(target: Vector2) -> void:
	if tween.is_active():
		tween.stop(self, "position")
	tween.interpolate_property(self, "position", position, target, 0.2, Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.start()
