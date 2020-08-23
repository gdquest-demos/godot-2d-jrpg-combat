class_name Action
extends Resource

export var icon: ImageTexture
export var description := "Base combat action"


# Returns `true` if the action succeeded.
func _apply(_actor: Battler, _targets: Array) -> bool:
	return true


# Returns `true` if the action can be used.
func _can_use() -> bool:
	return true


# Returns `true` if the action should target opponents by default.
func _target_opponents() -> bool:
	return true
