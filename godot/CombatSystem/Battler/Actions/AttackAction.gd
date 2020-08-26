tool
extends Action
class_name AttackAction


func _init() -> void:
	label = "Attack"


func _apply(actor, targets: Array) -> bool:
	for target in targets:
		var damage = actor.get_damage()
		actor.play("attack")
		target.take_damage(damage)
		target.play("take_damage")
		print(
			(
				"%s dealt %s damage to %s. Health: %s"
				% [actor.name, damage, target.name, target.stats.health]
			)
		)
		yield(actor, "animation_finished")
	emit_signal("finished")
	return true
