tool
extends Panel

export var text := "" setget set_text

onready var label: Label = $Label
onready var anim_player: AnimationPlayer = $AnimationPlayer


func set_text(value: String) -> void:
	text = value
	if not is_inside_tree():
		yield(self, "ready")
	label.text = text


func fade_in() -> void:
	anim_player.play("fade_in")


func fade_out() -> void:
	anim_player.play("fade_out")
