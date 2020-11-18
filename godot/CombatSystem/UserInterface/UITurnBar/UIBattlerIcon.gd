# Icon representing a battler on the [UITurnBar].
# Moves along the turn bar as the associated battler's readiness updates.
tool
class_name UIBattlerIcon
extends TextureRect

enum Types { ALLY, PLAYER, ENEMY }

const TYPES := {
	Types.ALLY: preload("portrait_bg_ally.png"),
	Types.PLAYER: preload("portrait_bg_player.png"),
	Types.ENEMY: preload("portrait_bg_enemy.png"),
}

export var icon: Texture setget set_icon
export (Types) var type: int = Types.ENEMY setget set_type

var position_range := Vector2.ZERO

onready var _icon_node := $Icon


func snap(ratio: float) -> void:
	rect_position.x = lerp(position_range.x, position_range.y, ratio)


func set_icon(value: Texture) -> void:
	icon = value
	if not is_inside_tree():
		yield(self, "ready")
	_icon_node.texture = icon


func set_type(value: int) -> void:
	type = value
	texture = TYPES[type]
