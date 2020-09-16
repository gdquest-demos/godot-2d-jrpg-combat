# Keeps track of status effects active on a [Battler].
# Adds and removes status effects as necessary.
# Intended to be placed as a child of a Battler.
class_name StatusEffectContainer
extends Node

# Maximum number of instances of one type of status effect that can be applied to one battler at a
# time.
const MAX_STACKS := 5
const STACKING_EFFECTS := ["bug"]
const NON_STACKING_EFFECTS := ["haste", "slow"]

# Updated by another node.
var time_scale := 1.0 setget set_time_scale
var is_active := true setget set_is_active


# Adds a new instance of a status effect as a child, ensuring the effects don't stack past
# `MAX_STACKS`.
func add(effect: StatusEffect) -> void:
	if effect.can_stack():
		if _has_maximum_stacks_of(effect.id):
			_remove_effect_expiring_the_soonest(effect.id)
	elif has_node(effect.name):
		get_node(effect.name).expire()
	add_child(effect)


# Removes all stacks of an effect of a given type.
func remove_type(id: String) -> void:
	for effect in get_children():
		if effect.id == id:
			effect.expire()


# Removes all status effects.
func remove_all() -> void:
	for effect in get_children():
		effect.expire()


func set_time_scale(value: float) -> void:
	time_scale = value
	for effect in get_children():
		effect.time_scale = time_scale


func set_is_active(value) -> void:
	is_active = value
	for effect in get_children():
		effect.is_active = is_active


func _has_maximum_stacks_of(id: String) -> bool:
	var count := 0
	for effect in get_children():
		if effect.id == id:
			count += 1
	return count == MAX_STACKS


func _remove_effect_expiring_the_soonest(id: String) -> void:
	var to_remove: StatusEffect
	var smallest_time: float = INF
	for effect in get_children():
		if effect.id != id:
			continue
		var time_left: float = effect.get_time_left()
		if time_left < smallest_time:
			to_remove = effect
			smallest_time = time_left
	to_remove.expire()
