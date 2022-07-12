# Abstract base class for all combat actions.
# Constructed from an [ActionData] resource
# Actions take an actor and an array of targets. The actor applies the action to the targets, which involves sequencing and playing animations.
# Because of that, actions rely on coroutines and must emit the signal "finished" when the action is over.
# See derived classes like [AttackAction] for concrete examples.
# Implements the Command pattern. For more information, see http://gameprogrammingpatterns.com/command.html
class_name Action
extends Reference

# Emitted when the action finished playing.
signal finished

var _data: ActionData
var _actor
var _targets := []


func _init(data: ActionData, actor, targets: Array) -> void:
	_data = data
	_actor = actor
	_targets = targets


# Executes the action initiated by the `actor` battler on the `targets`.
# The function must be a coroutine or the game will freeze.
# Returns `true` if the action succeeded.
func apply_async() -> bool:
	yield(Engine.get_main_loop(), "idle_frame")
	emit_signal("finished")
	return true


# Returns `true` if the action should target opponents by default.
func targets_opponents() -> bool:
	return true


func get_readiness_saved() -> float:
	return _data.readiness_saved


func get_energy_cost() -> int:
	return _data.energy_cost
