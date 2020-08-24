extends VBoxContainer

signal action_selected(action)

const UIMenuAction: PackedScene = preload("res://CombatSystem/UserInterface/UIActionMenu/UIMenuAction.tscn")

var is_disabled = false setget set_is_disabled

func _ready() -> void:
	for child in get_children():
		child.queue_free()


func setup(actions: Array) -> void:
	for action in actions:
		var menu_action = UIMenuAction.instance()
		add_child(menu_action)
		menu_action.setup(action)
		menu_action.connect("pressed", self, "_on_UIMenuAction_button_pressed", [action])


func focus() -> void:
	get_child(0).grab_focus()


func set_is_disabled(value: bool) -> void:
	is_disabled = value
	for child in get_children():
		child.disabled = is_disabled


# The action may be opening another menu
func _on_UIMenuAction_button_pressed(action: Action) -> void:
	set_is_disabled(true)
	emit_signal("action_selected", action)
