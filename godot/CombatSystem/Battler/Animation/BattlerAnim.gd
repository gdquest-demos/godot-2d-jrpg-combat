class_name BattlerAnim
extends Position2D

signal animation_finished(name)

onready var anim_player: AnimationPlayer = $Pivot/AnimationPlayer
onready var anchor: Position2D = $FrontAnchor


func play(anim_name: String) -> void:
	anim_player.play(anim_name)
	anim_player.seek(0.0)


func queue_animation(anim_name: String) -> void:
	anim_player.queue(anim_name)


func get_anchor_global_position() -> Vector2:
	return anchor.global_position


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	emit_signal("animation_finished", anim_name)
