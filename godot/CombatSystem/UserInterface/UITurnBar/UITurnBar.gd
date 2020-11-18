# Timeline representing the turn order of all battlers in the arena.
# Battlers move along the timeline as their readiness rating updates.
extends Control

const BattlerIcon := preload("UIBattlerIcon.tscn")

onready var _background: TextureRect = $Background
onready var _anim_player: AnimationPlayer = $AnimationPlayer


func setup(battlers: Array) -> void:
	for battler in battlers:
		var type: int = (
			UIBattlerIcon.Types.PLAYER
			if battler.is_party_member
			else UIBattlerIcon.Types.ENEMY
		)
		var icon: UIBattlerIcon = create_icon(type, battler.ui_data.texture)
		_background.add_child(icon)
		battler.connect("readiness_changed", self, "_on_Battler_readiness_changed", [icon])


# Creates a new instance of [UIBattlerIcon], initializes it, and adds it as a child of `_background`.
func create_icon(type: int, texture: Texture) -> UIBattlerIcon:
	var icon: UIBattlerIcon = BattlerIcon.instance()
	icon.icon = texture
	icon.type = type
	icon.position_range = Vector2(
		-icon.rect_size.x / 2.0, -icon.rect_size.x / 2.0 + _background.rect_size.x
	)
	return icon


func fade_in() -> void:
	_anim_player.play("fade_in")


func fade_out() -> void:
	_anim_player.play("fade_out")


func _on_Battler_readiness_changed(readiness: float, icon: UIBattlerIcon) -> void:
	icon.snap(readiness / 100.0)
