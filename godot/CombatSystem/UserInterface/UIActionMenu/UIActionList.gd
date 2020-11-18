# List of UIActionButton the player can press to select an action.
extends VBoxContainer

signal action_selected(action)

const UIActionButton: PackedScene = preload("UIActionButton.tscn")

var is_disabled = false setget set_is_disabled
var buttons := []

onready var _select_arrow := $UIMenuSelectArrow


func setup(battler: Battler) -> void:
	for action in battler.actions:
		var can_use_action: bool = battler.stats.energy >= action.energy_cost
		var action_button = UIActionButton.instance()
		add_child(action_button)
		action_button.setup(action, can_use_action)
		action_button.connect("pressed", self, "_on_UIActionButton_button_pressed", [action])
		action_button.connect(
			"focus_entered", self, "_on_UIActionButton_focus_entered", [action_button, battler.ui_data.display_name, action.energy_cost]
		)
		buttons.append(action_button)

	_select_arrow.position = (
		buttons[0].rect_global_position
		+ Vector2(0.0, buttons[0].rect_size.y / 2.0)
	)


func focus() -> void:
	buttons[0].grab_focus()


func set_is_disabled(value: bool) -> void:
	is_disabled = value
	for button in buttons:
		button.disabled = is_disabled


# The action may be opening another menu
func _on_UIActionButton_button_pressed(action: ActionData) -> void:
	set_is_disabled(true)
	emit_signal("action_selected", action)


func _on_UIActionButton_focus_entered(button: TextureButton, battler_display_name: String, energy_cost: int) -> void:
	_select_arrow.move_to(button.rect_global_position + Vector2(0.0, button.rect_size.y / 2.0))
	Events.emit_signal("combat_action_hovered", battler_display_name, energy_cost)
