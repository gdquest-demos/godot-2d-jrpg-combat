# Data container used to construct [AttackAction] objects.
class_name AttackActionData
extends ActionData

export var damage_multiplier := 1.0
export var hit_chance := 100.0
export var status_effect: Resource


# Returns the total damage for the action, factoring in damage dealt by a status effect.
func calculate_potential_damage_for(battler) -> int:
	var total_damage: int = int(Formulas.calculate_potential_damage(self, battler))
	if status_effect:
		total_damage += status_effect.calculate_total_damage()
	return total_damage
