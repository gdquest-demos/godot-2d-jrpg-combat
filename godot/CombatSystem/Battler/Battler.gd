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
# Array of available actions for this unit.
export var actions: Array
# If true, this battler is part of the player's party and it targets enemy units
export var is_party_member := false
export var ui_data: Resource

# Provided by the ActiveTurnQueue.
var time_scale := 1.0
var is_active: bool = true setget set_is_active
var is_selected: bool = false setget set_is_selected
var is_selectable: bool = true setget set_is_selectable

var _readiness := 0.0 setget _set_readiness

onready var battler_anim: BattlerAnim = $BattlerAnim


func _ready() -> void:
	assert(stats is BattlerStats)
	stats.connect("health_depleted", self, "_on_Stats_health_depleted")


func _process(delta: float) -> void:
	_set_readiness(_readiness + stats.speed * delta * time_scale)
	if _readiness >= 100.0:
		emit_signal("ready_to_act")
		set_process(false)


func act(action, targets: Array) -> void:
	yield(action.apply_async(self, targets), "completed")
	battler_anim.move_back()
	_set_readiness(0.0)
	set_process(true)
	emit_signal("action_finished")


func get_damage() -> float:
	return stats.attack


func take_damage(amount: float) -> void:
	stats.health -= amount
	if stats.health > 0:
		battler_anim.play("take_damage")


func get_anchor_global_position() -> Vector2:
	return battler_anim.get_anchor_global_position()


func is_player_controlled() -> bool:
	return ai == null


func is_fallen() -> bool:
	return stats.health == 0


func set_is_active(value):
	is_active = value
	set_process(is_active)


func set_is_selected(value):
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
