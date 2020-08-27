# Must emit the signal "completed" when the action completed.
class_name Action
extends Resource

export var icon: Texture
export var label := "Base combat action"

export var is_targetting_self := false
export var is_targetting_all := false


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
