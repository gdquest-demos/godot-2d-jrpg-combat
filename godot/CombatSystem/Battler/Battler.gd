# Character or monster that's participating in combat.
# Any battler can be given an AI and turn into a computer-controlled ally or a foe.
extends Node2D
class_name Battler

# Emitted when the battler is ready to take a turn.
signal ready_to_act
signal animation_finished(anim_name)
signal action_finished
signal readiness_changed(new_value)
signal health_depleted
signal selection_toggled(value)

export var stats: Resource
export var ai: Resource = null
# Array of ActionData, from which we construct actions for this unit.
export var actions: Array
# If true, this battler is part of the player's party and it targets enemy units
export var is_party_member := false
export var ui_data: Resource

# Provided by the ActiveTurnQueue.
var time_scale := 1.0 setget set_time_scale
# If `true`, the battler's readiness updates every frame.
var is_active: bool = true setget set_is_active
# If `true`, the battler is selected, which makes it move forward.
# This property is intended for player-controlled characters.
var is_selected: bool = false setget set_is_selected
# If `false`, the battler cannot be targeted by any action.
var is_selectable: bool = true setget set_is_selectable

var _readiness := 0.0 setget _set_readiness
var _status_effects := []

onready var battler_anim: BattlerAnim = $BattlerAnim


func _ready() -> void:
	assert(stats is BattlerStats)
	stats = stats.duplicate()
	stats.reinitialize()
	stats.connect("health_depleted", self, "_on_Stats_health_depleted")


func _process(delta: float) -> void:
	_set_readiness(_readiness + stats.speed * delta * time_scale)
	if _readiness >= 100.0:
		emit_signal("ready_to_act")
		set_process(false)


func setup(battlers: Array) -> void:
	if ai:
		ai.setup(self, battlers)


# Makes the battler apply an [Action] to the `targets` and resets the battler's readiness.
#
# Arguments:
# - action: Action, the combat action to apply.
# - targets: Array[Battler], the battlers on which to apply the action.
func act(action_data, targets: Array) -> void:
	stats.energy -= action_data.energy_cost
	var action = AttackAction.new(action_data, self, targets)
	yield(action.apply_async(), "completed")
	battler_anim.move_back()
	_set_readiness(action_data.readiness_saved)
	if is_active:
		set_process(true)
	emit_signal("action_finished")


func get_damage() -> float:
	return stats.attack


func take_damage(amount: float) -> void:
	stats.health -= amount
	if stats.health > 0:
		battler_anim.play("take_damage")


func apply_status_effect(effect: StatusEffect) -> void:
	add_child(effect)


func get_front_anchor_global_position() -> Vector2:
	return battler_anim.get_front_anchor_global_position()


func get_top_anchor_global_position() -> Vector2:
	return battler_anim.get_top_anchor_global_position()


func is_player_controlled() -> bool:
	return ai == null


func is_fallen() -> bool:
	return stats.health == 0


func set_is_active(value):
	is_active = value
	set_process(is_active)


func set_time_scale(value):
	time_scale = value
	for status_effect in _status_effects:
		status_effect.time_scale = time_scale


func set_is_selected(value):
	if value:
		assert(is_selectable)
	is_selected = value
	if is_selected:
		battler_anim.move_forward()
	emit_signal("selection_toggled", is_selected)


func set_is_selectable(value):
	is_selectable = value
	if not is_selectable:
		set_is_selected(false)


func _set_readiness(value: float) -> void:
	_readiness = value
	emit_signal("readiness_changed", _readiness)


func _on_BattlerAnim_animation_finished(anim_name) -> void:
	emit_signal("animation_finished", anim_name)


func _on_Stats_health_depleted() -> void:
	emit_signal("health_depleted")
	if not is_party_member:
		set_is_selectable(false)
		set_is_active(false)
		battler_anim.queue_animation("die")
