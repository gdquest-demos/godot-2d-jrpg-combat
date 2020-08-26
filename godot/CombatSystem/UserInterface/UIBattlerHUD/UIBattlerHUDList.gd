extends VBoxContainer

const UIBattlerHUD: PackedScene = preload(
	"res://CombatSystem/UserInterface/UIBattlerHUD/UIBattlerHUD.tscn"
)


# Arguments:
# - battler_stats: Array[BattlerStats]
func setup(battler_stats: Array) -> void:
	for stats in battler_stats:
		var battler_hud: UIBattlerHUD = UIBattlerHUD.instance()
		add_child(battler_hud)
		battler_hud.setup(stats)
