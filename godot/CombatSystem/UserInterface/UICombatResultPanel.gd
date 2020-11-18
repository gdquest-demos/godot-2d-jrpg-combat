tool
extends Panel

export var text := "" setget set_text

onready var _label: Label = $Label
onready var _anim_player: AnimationPlayer = $AnimationPlayer


func set_text(value: String) -> void:
	text = value
	if not is_inside_tree():
		yield(self, "ready")
	_label.text = text


func fade_in() -> void:
	_anim_player.play("fade_in")


func fade_out() -> void:
	_anim_player.play("fade_out")
