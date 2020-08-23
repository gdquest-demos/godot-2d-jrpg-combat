# Character or monster that's participating in combat.
# Any battler can be given an AI and turn into a computer-controlled ally or a foe.
extends Node2D
class_name Battler

# Emitted when the battler is ready to take a turn
signal ready_to_act

export var display_name := ""
export var stats: Resource
export var ai: Resource
# Array of available actions for this unit.
export var actions: Array
# If true, this battler is part of the player's party and it targets enemy units
export var is_party_member := false

# Provided by the ActiveTurnQueue.
var time_scale := 1.0
var is_selected: bool = false setget set_is_selected
var is_selectable: bool = false setget set_is_selectable

var _readiness := 0.0

onready var skin: BattlerSkin = $Skin


func _ready() -> void:
	assert(stats is Stats)


func _process(delta: float) -> void:
	_readiness += stats.speed * delta * time_scale
	if _readiness >= 100.0:
		emit_signal("ready_to_act")
		set_process(false)


func act(action, targets: Array) -> void:
	yield(action.act(self, targets), "completed")
	set_process(true)


func set_is_selected(value):
	is_selected = value
	skin.is_blinking = value


func set_is_selectable(value):
	is_selectable = value
	if not is_selectable:
		set_is_selected(false)
