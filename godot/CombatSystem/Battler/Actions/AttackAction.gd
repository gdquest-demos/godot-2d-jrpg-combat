tool
extends Action
class_name AttackAction


func _init() -> void:
	label = "Attack"


func _apply_async(actor, targets: Array) -> bool:
	for target in targets:
		var damage = actor.get_damage()
		actor.play("attack")
		target.take_damage(damage)
		yield(actor, "animation_finished")
	return true
