class_name UIActionMenu
extends Control

signal action_selected

onready var list := $UIActionsList


func _ready() -> void:
	hide()


func open(actions: Array) -> void:
	list.setup(actions)
	show()
	list.focus()


func close() -> void:
	hide()
	queue_free()


func _on_UIActionsList_action_selected(action: Action) -> void:
	emit_signal("action_selected", action)
	close()
