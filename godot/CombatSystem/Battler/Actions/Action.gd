# Abstract base class for all combat actions.
# Add an action to [Battler.actions] to allow them to use it.
# Actions take an actor and an array of targets. The actor applies the action to the targets, which involves sequencing and playing animations.
# Because of that, actions rely on coroutines and must emit the signal "finished" when the action is over.
# See derived classes like [AttackAction] for concrete examples.
# Implements the Command pattern. For more information, see http://gameprogrammingpatterns.com/command.html
class_name Action
extends Resource

# Emitted when the action finished playing.
signal finished

export var icon: Texture
export var label := "Base combat action"

export var is_targetting_self := false
export var is_targetting_all := false


# Applies the action on `_targets` using `_actor`'s stats.
func apply_async(_actor, _targets: Array) -> bool:
	return _apply_async(_actor, _targets)


# Executes the action initiated by the `actor` battler on the `targets`.
# The function must be a coroutine or the game will freeze.
# Returns `true` if the action succeeded.
func _apply_async(_actor, _targets: Array) -> bool:
	emit_signal("finished")
	return true


# Returns `true` if the action can be used.
func _can_use(_actor) -> bool:
	return true


# Returns `true` if the action should target opponents by default.
func _target_opponents() -> bool:
	return true
