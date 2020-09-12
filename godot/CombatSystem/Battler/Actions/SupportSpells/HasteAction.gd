# Concrete class for basic damaging attacks. Inflicts direct damage to one or more targets.
class_name HasteAction
extends Action

var duration_seconds := 5.0
var haste_rate := 0.8

var _hits := []


func _init(data: ActionData, actor, targets: Array).(data, actor, targets) -> void:
	pass


func _apply_async() -> bool:
	var anim = _actor.battler_anim
	if not anim.is_connected("triggered", self, "_on_BattlerAnim_triggered"):
		anim.connect("triggered", self, "_on_BattlerAnim_triggered")
	for target in _targets:
		var haste_effect := StatusEffectHaste.new(target, duration_seconds, haste_rate)
		_hits.append(Hit.new(target, 0, haste_effect))
		anim.play("attack")
		yield(_actor, "animation_finished")
	return true


func _on_BattlerAnim_triggered() -> void:
	var hit: Hit = _hits.pop_front()
	hit.apply()
