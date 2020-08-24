# Must emit the signal "completed" when the action completed.
class_name Action
extends Resource

signal finished

export var icon: Texture
export var label := "Base combat action"


func apply(_actor, _targets: Array) -> bool:
	return _apply(_actor, _targets)


# Returns `true` if the action succeeded.
func _apply(_actor, _targets: Array) -> bool:
	emit_signal("finished")
	return true


# Returns `true` if the action can be used.
func _can_use() -> bool:
	return true


# Returns `true` if the action should target opponents by default.
func _target_opponents() -> bool:
	return true
