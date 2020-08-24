extends Sprite

onready var tween: Tween = $Tween


func _init() -> void:
	set_as_toplevel(true)


func move_to(target: Vector2) -> void:
	if tween.is_active():
		tween.stop(self, "position")
	tween.interpolate_property(self, "position", position, target, 0.1, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
