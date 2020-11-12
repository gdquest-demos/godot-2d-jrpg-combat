# Menu displaying lists of actions the player can select.
# Can contain multiple nested UIActionsList.
class_name UIActionMenu
extends Control

signal action_selected

const UIActionList := preload("UIActionList.tscn")


func _ready() -> void:
	hide()


func open(battler: Battler) -> void:
	var list = UIActionList.instance()
	add_child(list)
	list.connect("action_selected", self, "_on_UIActionsList_action_selected")
	list.setup(battler)
	show()
	list.focus()


func close() -> void:
	hide()
	queue_free()


func _on_UIActionsList_action_selected(action: ActionData) -> void:
	emit_signal("action_selected", action)
	close()
