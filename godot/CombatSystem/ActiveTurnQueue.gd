# Queues and delegates turns for all battlers.
class_name ActiveTurnQueue
extends Node

signal player_turn_finished

export var UIActionMenuScene: PackedScene
export var SelectArrow: PackedScene

# Allows pausing the Active Time Battle during combat intro, a cut-scene, or combat end.
var is_active := true setget set_is_active
# Multiplier for the global pace of battle, to slow down time while the player is taking decisions.
# This is meant for accessibility and to control difficulty.
var time_scale := 1.0 setget set_time_scale

# Stack of player units that have to take turns.
var _queue_player := []

var _party_members := []
var _opponents := []

var _is_player_playing := false

onready var battlers := get_children()


func _ready() -> void:
	connect("player_turn_finished", self, "_on_player_turn_finished")
	for battler in battlers:
		battler.setup(battlers)
		battler.connect("ready_to_act", self, "_on_Battler_ready_to_act", [battler])
		if battler.is_party_member:
			_party_members.append(battler)
		else:
			_opponents.append(battler)


func set_is_active(value: bool) -> void:
	is_active = value
	for battler in battlers:
		battler.is_active = is_active


func set_time_scale(value: float) -> void:
	time_scale = value
	for battler in battlers:
		battler.time_scale = time_scale


func _play_turn(battler: Battler) -> void:
	battler.stats.energy += 1

	var action_data: ActionData
	var targets := []

	var potential_targets := []
	var opponents := _opponents if battler.is_party_member else _party_members
	for opponent in opponents:
		if opponent.is_selectable:
			potential_targets.append(opponent)

	if battler.is_player_controlled():
		battler.is_selected = true
		_is_player_playing = true
		set_time_scale(0.05)
		var is_selection_complete := false
		# Wait for the player to select a valid action and target(s).
		while not is_selection_complete:
			action_data = yield(_player_select_action_async(battler), "completed")
			if action_data.is_targeting_self:
				targets = [battler]
			else:
				targets = yield(
					_player_select_targets_async(action_data, potential_targets), "completed"
				)
				Events.emit_signal("player_target_selection_done")
			is_selection_complete = action_data != null && targets != []
		set_time_scale(1.0)
		battler.is_selected = false
	else:
		var result: Dictionary = battler.get_ai().choose()
		action_data = result.action
		targets = result.targets

	var action = AttackAction.new(action_data, battler, targets)
	battler.act(action)
	yield(battler, "action_finished")


	if battler.is_player_controlled():
		emit_signal("player_turn_finished")


func _player_select_action_async(battler: Battler) -> ActionData:
	var action_menu: UIActionMenu = UIActionMenuScene.instance()
	add_child(action_menu)
	action_menu.open(battler)
	var data: ActionData = yield(action_menu, "action_selected")
	return data


func _player_select_targets_async(_action: ActionData, opponents: Array) -> Array:
	var arrow: UISelectBattlerArrow = SelectArrow.instance()
	add_child(arrow)
	arrow.setup(opponents)
	var targets = yield(arrow, "target_selected")
	arrow.queue_free()
	return targets


func _on_player_turn_finished() -> void:
	if _queue_player.empty():
		_is_player_playing = false
	else:
		_play_turn(_queue_player.pop_front())


func _on_Battler_ready_to_act(battler: Battler) -> void:
	if battler.is_player_controlled() and _is_player_playing:
		_queue_player.append(battler)
	else:
		_play_turn(battler)
