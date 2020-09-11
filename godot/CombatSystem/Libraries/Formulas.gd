class_name Formulas
extends Reference


# Damage formula:
# (attacker_attack - defender_defense) * action_damage_multiplier * weakness_multiplier
# Damage is in the range [0, 999]
static func calculate_base_damage(action: AttackAction, attacker: Battler, defender: Battler) -> int:
	var damage: float = (
		(attacker.stats.attack - defender.stats.defense)
		* action.get_damage_multiplier()
	)
	damage *= _calculate_weakness_multiplier(action, defender)
	return int(clamp(damage, 0.0, 999.0))


# Hit chance formula:
# (attacker_hit - defender_evasion) * action_hit + element_triad_bonus
# Return value is in the range [0, 100]
static func calculate_hit_chance(action: AttackAction, attacker: Battler, defender: Battler) -> float:
	var chance: float = attacker.stats.hit_chance - defender.stats.evasion
	chance *= action.get_hit_chance() / 100.0
	var element: int = action.get_element()
	if element != Types.Elements.NONE:
		if Types.WEAKNESS_MAPPING[defender.stats.element] == element:
			chance += 10.0
		elif Types.WEAKNESS_MAPPING[element] in defender.stats.weaknesses:
			chance -= 10.0
	return clamp(chance, 0.0, 100.0)


# Returns:
# - 1.5 if the defender is weak against the action
# - 0.75 if the defender is strong against the action
# - 1.0 otherwise
static func _calculate_weakness_multiplier(action: AttackAction, defender: Battler) -> float:
	var multiplier := 1.0
	var element: int = action.get_element()
	if element != Types.Elements.NONE:
		if Types.WEAKNESS_MAPPING[defender.stats.element] == element:
			multiplier = 0.75
		elif Types.WEAKNESS_MAPPING[element] in defender.stats.weaknesses:
			multiplier = 1.5
	return multiplier
