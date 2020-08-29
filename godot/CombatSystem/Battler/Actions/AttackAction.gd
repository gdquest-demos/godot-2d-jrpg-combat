tool
extends Action
class_name AttackAction


var hits := []


func _init() -> void:
	label = "Attack"


func _apply_async(actor, targets: Array) -> bool:
	var anim: BattlerAnim = actor.battler_anim
	anim.connect("triggered", self, "_on_BattlerAnim_triggered")
	for target in targets:
		hits.append(Hit.new(target, actor.get_damage()))
		anim.play("attack")
		yield(actor, "animation_finished")
	return true


func _on_BattlerAnim_triggered() -> void:
	var hit: Hit = hits.pop_front()
	hit.apply()
