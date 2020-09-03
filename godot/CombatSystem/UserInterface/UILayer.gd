extends CanvasLayer

const UICombatResultPanel: PackedScene = preload("UICombatResultPanel.tscn")


func _on_CombatDemo_combat_ended(message) -> void:
	var ui_result: Control = UICombatResultPanel.instance()
	ui_result.text = message
	add_child(ui_result)
