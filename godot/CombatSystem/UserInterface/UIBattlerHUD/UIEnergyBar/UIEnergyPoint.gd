# Represents one energy point. This node has two animations and functions to make it appear and disappear smoothly.
extends TextureRect

onready var anim_player := $AnimationPlayer


func appear() -> void:
	anim_player.play("fade_in")


func disappear() -> void:
	anim_player.play("fade_out")
