# Spawns labels that display damage, healing, or missed hits.
class_name UIDamageLabelBuilder
extends Node2D

export var damage_label_scene: PackedScene = preload("UIDamageLabel.tscn")
export var miss_label_scene: PackedScene = preload("UIMissedLabel.tscn")


func register_action(action) -> void:
	if action is AttackAction:
		action.connect("damage_dealt", self, "_on_AttackAction_damage_dealt")
		action.connect("missed", self, "_on_AttackAction_missed")


func _on_AttackAction_damage_dealt(amount: int, target: Battler) -> void:
	var label: UIDamageLabel = damage_label_scene.instance()
	label.setup(UIDamageLabel.Types.DAMAGE, target.get_top_anchor_global_position(), amount)
	add_child(label)


func _on_AttackAction_missed(target: Battler) -> void:
	var label = miss_label_scene.instance()
	add_child(label)
	label.global_position = target.get_top_anchor_global_position()
