tool
extends Action
class_name AttackAction


func _init() -> void:
	label = "Attack"


func _apply(actor, targets: Array) -> bool:
	for t in targets:
		var damage = actor.get_damage()
		actor.play("attack")
		t.take_damage(damage)
		t.play("take_damage")
		print("%s dealt %s damage to %s. Health: %s" % [actor.name, damage, t.name, t.stats.health])
		yield(actor, "animation_finished")
	emit_signal("finished")
	return true
