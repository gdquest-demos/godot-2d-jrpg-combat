# Template for basic damaging attacks. Inflicts direct damage to one or more targets.
tool
extends Action
class_name AttackAction

export var damage_multiplier := 1.0

var _hits := []

func _init() -> void:
	label = "Attack"


# Plays the acting battler's attack animation once for each target. Damages each target when the actor's animation emits the `triggered` signal.
func _apply_async(actor, targets: Array) -> bool:
	var anim: BattlerAnim = actor.battler_anim
	if not anim.is_connected("triggered", self, "_on_BattlerAnim_triggered"):
		anim.connect("triggered", self, "_on_BattlerAnim_triggered")
	for target in targets:
		_hits.append(Hit.new(target, actor.get_damage()))
		anim.play("attack")
		yield(actor, "animation_finished")
	return true


func _on_BattlerAnim_triggered() -> void:
	var hit: Hit = _hits.pop_front()
	hit.apply()
