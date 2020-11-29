# Spawns labels that display damage, healing, or missed hits.
class_name UIDamageLabelBuilder
extends Node2D

export var damage_label_scene: PackedScene = preload("UIDamageLabel.tscn")
export var miss_label_scene: PackedScene = preload("UIMissedLabel.tscn")


func setup(battlers: Array) -> void:
	for battler in battlers:
		battler.connect("damage_taken", self, "_on_Battler_damage_taken", [battler])
		battler.connect("hit_missed", self, "_on_Battler_hit_missed", [battler])
		

func _on_Battler_damage_taken(amount: int, target: Battler) -> void:
	var label: UIDamageLabel = damage_label_scene.instance()
	label.setup(UIDamageLabel.Types.DAMAGE, target.battler_anim.get_top_anchor_global_position(), amount)
	add_child(label)


func _on_Battler_hit_missed(target: Battler) -> void:
	var label = miss_label_scene.instance()
	add_child(label)
	label.global_position = target.battler_anim.get_top_anchor_global_position()
