class_name BattlerAnim
extends Position2D

signal animation_finished(name)

onready var anim_player: AnimationPlayer = $Pivot/AnimationPlayer


func play(anim_name: String) -> void:
	anim_player.play(anim_name)


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	emit_signal("animation_finished", anim_name)
