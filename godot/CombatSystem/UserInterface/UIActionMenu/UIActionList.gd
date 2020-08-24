extends VBoxContainer

signal action_selected(action)

const UIActionButton: PackedScene = preload("res://CombatSystem/UserInterface/UIActionMenu/UIActionButton.tscn")

var is_disabled = false setget set_is_disabled
var buttons := []

onready var select_arrow := $UIMenuSelectArrow


func setup(actions: Array) -> void:
	for action in actions:
		var action_button = UIActionButton.instance()
		add_child(action_button)
		action_button.setup(action)
		action_button.connect("pressed", self, "_on_UIActionButton_button_pressed", [action])
		action_button.connect("focus_entered", self, "_on_UIActionButton_focus_entered", [action_button])
		buttons.append(action_button)

	select_arrow.position = buttons[0].rect_global_position + Vector2(0.0, buttons[0].rect_size.y / 2.0)


func focus() -> void:
	buttons[0].grab_focus()


func set_is_disabled(value: bool) -> void:
	is_disabled = value
	for button in buttons:
		button.disabled = is_disabled


# The action may be opening another menu
func _on_UIActionButton_button_pressed(action: Action) -> void:
	set_is_disabled(true)
	emit_signal("action_selected", action)


func _on_UIActionButton_focus_entered(button: TextureButton) -> void:
	select_arrow.move_to(button.rect_global_position + Vector2(0.0, button.rect_size.y / 2.0))
