# Gives turns to battlers, time keeps
extends Node

var combat_menu: Control
# Allows pausing the Active Time Battle during combat intro or a cut-scene.
var is_active := true setget set_is_active
# Multiplier for the global pace of battle, to slow down time while the player is taking decisions.
# This is meant for accessibility and to control difficulty.
var time_scale := 1.0 setget set_time_scale

# Stack of player units that have to take turns.
var _player_turns := []
var _turn_in_progress := false

onready var battlers := get_children()


func _ready() -> void:
	for battler in battlers:
		battler.connect("ready_to_act", self, "_on_Battler_ready_to_act", [battler])


func set_is_active(value: bool) -> void:
	is_active = value
	for battler in battlers:
		battler.is_active = is_active


func set_time_scale(value: float) -> void:
	time_scale = value
	for battler in battlers:
		battler.time_scale = time_scale



func _play_turn(battler: Battler) -> void:
	battler.is_selected = true
	var action: Action
	var targets: Array

	var opponents := []
	for b in battlers:
		if b.is_party_member != battler.is_party_member:
			opponents.append(b)

	# TODO: Remove
	action = battler.actions[0]
	targets = [opponents[0]]
	# if battler.is_party_member:
	# 	combat_menu.open(battler)
	# 	yield(combat_menu, "action_selected")
	# else:
	# 	action = yield(battler.choose_action(battler, opponents), "completed")
	# 	targets = yield(battler.choose_target(battler, action, opponents), "completed")

	battler.selected = false
	battler.act(action, targets)


func _on_Battler_ready_to_act(battler: Battler) -> void:
	if battler.is_party_member:
		_player_turns.append(battler)
