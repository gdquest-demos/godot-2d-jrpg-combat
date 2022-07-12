# Concrete class for basic damaging attacks. Inflicts direct damage to one or more targets.
class_name AttackAction
extends Action

var _hits := []


func _init(data: AttackActionData, actor, targets: Array).(data, actor, targets) -> void:
	pass


# Plays the acting battler's attack animation once for each target. Damages each target when the actor's animation emits the `triggered` signal.
func apply_async() -> bool:
	var anim = _actor.battler_anim
	for target in _targets:
		var status: StatusEffect = StatusEffectBuilder.create_status_effect(
			target, _data.status_effect
		)
		var hit_chance := Formulas.calculate_hit_chance(_data, _actor, target)
		var damage := calculate_hit_damage(target)
		var hit := Hit.new(damage, hit_chance, status)
		anim.connect("triggered", self, "_on_BattlerAnim_triggered", [target, hit])
		anim.play("attack")
		yield(_actor, "animation_finished")
	return true


func _on_BattlerAnim_triggered(target, hit: Hit) -> void:
	target.take_hit(hit)


func calculate_hit_damage(target) -> int:
	return Formulas.calculate_base_damage(_data, _actor, target)


func get_damage_multiplier() -> float:
	return _data.damage_multiplier


func get_element() -> int:
	return _data.element


func get_hit_chance() -> int:
	return _data.hit_chance
