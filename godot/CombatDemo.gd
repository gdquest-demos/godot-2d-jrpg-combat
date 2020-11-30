extends Node2D

signal combat_ended(message)

enum CombatResult { DEFEAT, VICTORY }

onready var active_turn_queue := $ActiveTurnQueue
onready var ui_turn_bar := $UI/UITurnBar
onready var ui_battler_hud_list := $UI/UIBattlerHUDList
onready var ui_damage_label_builder := $UI/UIDamageLabelBuilder


func _ready() -> void:
	randomize()

	var battlers: Array = active_turn_queue.battlers
	var in_party := []
	for battler in battlers:
		battler.stats.connect("health_depleted", self, "_on_BattlerStats_health_depleted", [battler])
		if battler.is_party_member:
			in_party.append(battler)

	ui_turn_bar.setup(active_turn_queue.battlers)
	ui_battler_hud_list.setup(in_party)
	ui_damage_label_builder.setup(battlers)


# Returns an array of `Battler` who are in the same team as `actor`, including `actor`.
func get_ally_battlers_of(actor) -> Array:
	var team := []
	for battler in active_turn_queue.battlers:
		if battler.is_party_member == actor.is_party_member:
			team.append(battler)
	return team


func end_combat(result: int) -> void:
	active_turn_queue.is_active = false
	ui_turn_bar.fade_out()
	ui_battler_hud_list.fade_out()

	var message := "Victory" if result == CombatResult.VICTORY else "Defeat"
	emit_signal("combat_ended", message)


# Returns `true` if all battlers in the array are fallen.
# Arguments:
# - battlers: Array[Battler]
func are_all_fallen(battlers: Array) -> bool:
	var fallen_count := 0
	for battler in battlers:
		if battler.is_fallen():
			fallen_count += 1
	return fallen_count == battlers.size()


func _on_BattlerStats_health_depleted(actor) -> void:
	var team := get_ally_battlers_of(actor)
	if are_all_fallen(team):
		end_combat(CombatResult.DEFEAT if actor.is_party_member else CombatResult.VICTORY)
