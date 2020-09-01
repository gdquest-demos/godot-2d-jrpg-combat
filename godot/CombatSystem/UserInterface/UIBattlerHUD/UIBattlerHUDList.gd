extends VBoxContainer

const UIBattlerHUD: PackedScene = preload("UIBattlerHUD.tscn")


# Arguments:
# - battlers: Array[Battlers]
func setup(battlers: Array) -> void:
	for battler in battlers:
		var battler_hud: UIBattlerHUD = UIBattlerHUD.instance()
		add_child(battler_hud)
		battler_hud.setup(battler)
