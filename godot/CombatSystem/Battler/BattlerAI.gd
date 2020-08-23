class_name BattlerAI


# Selects an action based on the
# Arguments:
# - `actor: Battler`, the battler that's going to execute the action.
# - `targets: Array[Battler]`
# - `actions: Array[Action]`
func choose(_actor, _targets: Array, actions: Array) -> Action:
	return actions[0]
