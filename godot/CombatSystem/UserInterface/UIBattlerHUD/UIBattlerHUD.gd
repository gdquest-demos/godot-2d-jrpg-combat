# Displays a party member's name, health, and energy.
class_name UIBattlerHUD
extends TextureRect

onready var life_bar: TextureProgress = $UILifeBar
onready var energy_bar := $UIEnergyBar
onready var label := $Label
onready var anim_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	Events.connect("combat_action_hovered", self, "_on_Events_combat_action_hovered")
	Events.connect("player_target_selection_done", self, "_on_Events_player_target_selection_done")


# Initializes the health and energy bars using the battler's stats.
func setup(battler: Battler) -> void:
	battler.connect("selection_toggled", self, "_on_Battler_selection_toggled")

	label.text = battler.ui_data.display_name

	var stats: BattlerStats = battler.stats
	life_bar.max_value = stats.max_health
	life_bar.value = stats.health
	energy_bar.setup(stats.max_energy, stats.energy)

	stats.connect("health_changed", self, "_on_BattlerStats_health_changed")
	stats.connect("energy_changed", self, "_on_BattlerStats_energy_changed")


func _on_BattlerStats_health_changed(_old_value: float, new_value: float) -> void:
	life_bar.target_value = new_value


func _on_BattlerStats_energy_changed(_old_value: float, new_value: float) -> void:
	energy_bar.value = new_value


func _on_Battler_selection_toggled(value: bool) -> void:
	if value:
		anim_player.play("select")
	else:
		anim_player.play("deselect")


func _on_Events_combat_action_hovered(battler_name: String, energy_cost: int) -> void:
	if label.text == battler_name:
		energy_bar.selected_count = energy_cost


func _on_Events_player_target_selection_done() -> void:
	energy_bar.selected_count = 0
