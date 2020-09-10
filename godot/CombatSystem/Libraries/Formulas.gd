class_name Formulas
extends Reference

enum ElementalTypes { NONE, CODE, DESIGN, ART, BUG }

const WEAKNESS_MAPPING = {
	ElementalTypes.CODE: ElementalTypes.ART,
	ElementalTypes.ART: ElementalTypes.DESIGN,
	ElementalTypes.DESIGN: ElementalTypes.CODE,
}

static func calculate_base_damage(action: AttackAction, attacker: Battler, defender: Battler) -> int:
	var damage: float = (
		(attacker.stats.attack - defender.stats.defense)
		* action.get_damage_multiplier()
	)
	damage *= _calculate_weakness_multiplier(action, defender)
	return int(clamp(damage, 0.0, 999.0))


static func _calculate_weakness_multiplier(action: AttackAction, defender: Battler) -> float:
	var multiplier := 1.0
	var element: int = action.get_element()
	if WEAKNESS_MAPPING[defender.stats.element] == element:
		multiplier = 0.75
	elif WEAKNESS_MAPPING[element] in defender.stats.weaknesses:
		multiplier = 1.5
	return multiplier
