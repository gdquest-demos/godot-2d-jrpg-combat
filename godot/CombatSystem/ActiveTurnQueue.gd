# Gives turns to battlers, time keeps
extends Node


const UIActionMenuScene: PackedScene = preload("res://CombatSystem/UserInterface/UIActionMenu/UIActionMenu.tscn")

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
	set_is_active(false)

	battler.is_selected = true
	var action: Action
	var targets := []

	var opponents := []
	for b in battlers:
		if b.is_party_member != battler.is_party_member:
			opponents.append(b)

	if battler.ai == null:
		var action_menu: UIActionMenu = UIActionMenuScene.instance()
		add_child(action_menu)
		action_menu.open(battler.actions)
		action = yield(action_menu, "action_selected")
	# else:
	# 	action = yield(battler.choose_action(battler, opponents), "completed")
	# 	targets = yield(battler.choose_target(battler, action, opponents), "completed")
	targets = opponents
	battler.act(action, targets)
	yield(battler, "action_finished")
	set_is_active(true)


func _on_Battler_ready_to_act(battler: Battler) -> void:
	_play_turn(battler)
