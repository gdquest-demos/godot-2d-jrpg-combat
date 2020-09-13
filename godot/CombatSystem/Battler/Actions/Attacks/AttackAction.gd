# Concrete class for basic damaging attacks. Inflicts direct damage to one or more targets.
class_name AttackAction
extends Action

var _hits := []


func _init(data: ActionData, actor, targets: Array).(data, actor, targets) -> void:
	pass


# Plays the acting battler's attack animation once for each target. Damages each target when the actor's animation emits the `triggered` signal.
func _apply_async() -> bool:
	var anim = _actor.battler_anim
	if not anim.is_connected("triggered", self, "_on_BattlerAnim_triggered"):
		anim.connect("triggered", self, "_on_BattlerAnim_triggered")
	for target in _targets:
		var status: StatusEffect = StatusEffectBuilder.create_status_effect(
			target, _data.status_effect
		)
		var damage := calculate_hit_damage(target)
		_hits.append(Hit.new(target, damage, status))
		anim.play("attack")
		yield(_actor, "animation_finished")
	return true


func _on_BattlerAnim_triggered() -> void:
	var hit: Hit = _hits.pop_front()
	hit.apply()


func calculate_hit_damage(target) -> int:
	return Formulas.calculate_base_damage(self, _actor, target)


# Returns the total damage for the action, factoring in damage dealt by a status effect.
func calculate_total_damage() -> int:
	var total_damage := 0
	for target in _targets:
		var damage := calculate_hit_damage(target)
		if _data.status_effect:
			damage += _data.status_effect.calculate_total_damage()
		total_damage += damage
	return total_damage


func get_damage_multiplier() -> float:
	return _data.damage_multiplier


func get_element() -> int:
	return _data.element


func get_hit_chance() -> int:
	return _data.hit_chance
