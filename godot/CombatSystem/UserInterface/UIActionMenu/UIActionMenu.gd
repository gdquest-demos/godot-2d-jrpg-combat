class_name UIActionMenu
extends Control

signal action_selected

onready var select_arrow := $UIMenuSelectArrow
onready var list := $UIActionsList


func _ready() -> void:
	hide()


func open(actions: Array) -> void:
	list.setup(actions)
	show()


func _on_UIActionsList_action_selected(action: Action) -> void:
	emit_signal("action_selected", action)
