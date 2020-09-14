class_name AggressiveBattlerAI
extends BattlerAI


func _choose_action(info: Dictionary) -> ActionData:
	return info.strongest_action


func _choose_targets(_action: ActionData, info: Dictionary) -> Array:
	return [info.weakest_target]
