class_name UIDamageLabelBuilder
extends Node2D

export var damage_label_scene: PackedScene = preload("UIDamageLabel.tscn")


func setup(battlers: Array) -> void:
	for battler in battlers:
		var stats: BattlerStats = battler.stats
		stats.connect("health_changed", self, "_on_BattlerStats_health_changed", [battler])


func _on_BattlerStats_health_changed(old_value: int, new_value: int, battler: Battler) -> void:
	var type: int = UIDamageLabel.Types.HEAL if new_value > old_value else UIDamageLabel.Types.DAMAGE
	
	var label: UIDamageLabel = damage_label_scene.instance()
	label.setup(type, battler.get_top_anchor_global_position(), int(abs(new_value - old_value)))
	add_child(label)
