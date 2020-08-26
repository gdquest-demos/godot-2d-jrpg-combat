extends Control

const BattlerIcon := preload("res://CombatSystem/UserInterface/UITurnBar/UIBattlerIcon.tscn")

var icons := []

onready var background: TextureRect = $Background


func setup(battlers: Array) -> void:
	for battler in battlers:
		var type: int = (
			UIBattlerIcon.Types.PLAYER
			if battler.is_party_member
			else UIBattlerIcon.Types.ENEMY
		)
		var icon: UIBattlerIcon = create_icon(type, battler.ui_data.texture)
		battler.connect("readiness_changed", self, "_on_Battler_readiness_changed", [icon])


func create_icon(type: int, texture: Texture) -> UIBattlerIcon:
	var icon: UIBattlerIcon = BattlerIcon.instance()
	background.add_child(icon)
	icon.icon = texture
	icon.type = type
	icon.position_range = Vector2(
		-icon.rect_size.x / 2.0, -icon.rect_size.x / 2.0 + background.rect_size.x
	)
	return icon


func _on_Battler_readiness_changed(readiness: float, icon: UIBattlerIcon) -> void:
	icon.snap(readiness / 100.0)
