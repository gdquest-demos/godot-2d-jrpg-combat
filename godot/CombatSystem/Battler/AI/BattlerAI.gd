class_name BattlerAI
extends Resource


# Returns a dictionary representing an action and its targets.
# The dictionary has the form { action: Action, targets: Array[Battler] }
# Arguments:
# - `battlers: Array[Battler]`, all battlers on the field, including the actor
func choose(actor, battlers: Array) -> Dictionary:
	return _choose(actor, battlers)


# @tags: virtual
func _choose(actor, battlers: Array) -> Dictionary:
	var opponents := []
	var allies := []
	for battler in battlers:
		var is_opponent: bool = battler.is_party_member != actor.is_party_member
		if is_opponent:
			opponents.append(battler)
		else:
			allies.append(battler)

	return {
		action = actor.actions[0],
		targets = [opponents[0]]
	}
