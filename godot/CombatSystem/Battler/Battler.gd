# Character or monster that's participating in combat.
# Any battler can be given an AI and turn into a computer-controlled ally or a foe.
extends Node2D
class_name Battler

# Emitted when the battler is ready to take a turn.
signal ready_to_act
# Emitted when an animation from `battler_anim` finished playing.
signal animation_finished(anim_name)
# Emitted when the battler finished their action and arrived back at their rest
# position.
signal action_finished
signal readiness_changed(new_value)
signal selection_toggled(value)
signal damage_taken(amount)
signal hit_missed

export var stats: Resource
export var ai_scene: PackedScene
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
var _ai_instance = null

onready var battler_anim: BattlerAnim = $BattlerAnim
onready var _status_effect_container: StatusEffectContainer = $StatusEffectContainer


func _ready() -> void:
	assert(stats is BattlerStats)
	stats = stats.duplicate()
	stats.reinitialize()
	stats.connect("health_depleted", self, "_on_BattlerStats_health_depleted")


func _process(delta: float) -> void:
	_set_readiness(_readiness + stats.speed * delta * time_scale)


# Allows the AI brain to get a reference to all battlers on the field.
func setup(battlers: Array) -> void:
	if ai_scene:
		_ai_instance = ai_scene.instance()
		_ai_instance.setup(self, battlers)
		add_child(_ai_instance)


# Makes the battler apply an [Action] to the `targets` and resets the battler's readiness.
#
# Arguments:
# - action: Action, the combat action to apply.
func act(action) -> void:
	stats.energy -= action.get_energy_cost()
	yield(action.apply_async(), "completed")
	battler_anim.move_back()
	_set_readiness(action.get_readiness_saved())
	if is_active:
		set_process(true)
	emit_signal("action_finished")


# Applies a hit object to the battler, dealing damage or status effects.
func take_hit(hit: Hit) -> void:
	if hit.does_hit():
		_take_damage(hit.damage)
		emit_signal("damage_taken", hit.damage)
		if hit.effect:
			_apply_status_effect(hit.effect)
	else:
		emit_signal("hit_missed")


func get_ai() -> Node:
	return _ai_instance


func is_player_controlled() -> bool:
	return ai_scene == null


func is_fallen() -> bool:
	return stats.health == 0


func set_is_active(value) -> void:
	is_active = value
	_status_effect_container.is_active = value
	set_process(is_active)


func set_time_scale(value) -> void:
	time_scale = value
	_status_effect_container.time_scale = time_scale


func set_is_selected(value) -> void:
	if value:
		assert(is_selectable)
	is_selected = value
	if is_selected:
		battler_anim.move_forward()
	emit_signal("selection_toggled", is_selected)


func set_is_selectable(value) -> void:
	is_selectable = value
	if not is_selectable:
		set_is_selected(false)


func _take_damage(amount: int) -> void:
	stats.health -= amount
	if stats.health > 0:
		battler_anim.play("take_damage")


# effect: StatusEffect
func _apply_status_effect(effect) -> void:
	_status_effect_container.add(effect)


func _set_readiness(value: float) -> void:
	_readiness = value
	emit_signal("readiness_changed", _readiness)
	if _readiness >= 100.0:
		emit_signal("ready_to_act")
		set_process(false)


func _on_BattlerAnim_animation_finished(anim_name) -> void:
	emit_signal("animation_finished", anim_name)


func _on_BattlerStats_health_depleted() -> void:
	set_is_active(false)
	if not is_party_member:
		set_is_selectable(false)
		battler_anim.queue_animation("die")
