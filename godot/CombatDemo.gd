extends Node2D

onready var active_turn_queue := $ActiveTurnQueue
onready var ui_turn_bar := $UI/UITurnBar
onready var ui_battler_hud_list := $UI/UIBattlerHUDList


func _ready() -> void:
	var battlers: Array = active_turn_queue.battlers
	var in_party := []
	for battler in battlers:
		if battler.is_party_member:
			in_party.append(battler)
	var stats := []
	for battler in in_party:
		stats.append(battler.stats)

	ui_turn_bar.setup(active_turn_queue.battlers)
	ui_battler_hud_list.setup(stats)
