tool
extends Action
class_name EnergyChargeAction


func _init() -> void:
	label = "Charge"
	is_targetting_self = true


func _apply_async(actor, _targets: Array) -> bool:
	actor.stats.energy += 1
	yield(actor.get_tree(), "idle_frame")
	return true


func _can_use(_actor) -> bool:
	return _actor.stats.energy < _actor.stats.max_energy
