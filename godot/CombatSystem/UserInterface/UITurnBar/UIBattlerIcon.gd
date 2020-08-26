tool
class_name UIBattlerIcon
extends TextureRect

enum Types { ALLY, PLAYER, ENEMY }

export var icon: Texture setget set_icon

export (Types) var type: int = Types.ENEMY setget set_type

var position_range := Vector2.ZERO

var _types := {
	Types.ALLY: load("res://CombatSystem/UserInterface/UITurnBar/portrait_bg_ally.png"),
	Types.PLAYER: load("res://CombatSystem/UserInterface/UITurnBar/portrait_bg_player.png"),
	Types.ENEMY: load("res://CombatSystem/UserInterface/UITurnBar/portrait_bg_enemy.png"),
}

onready var _icon_node := $Icon


func snap(amount: float) -> void:
	rect_position.x = lerp(position_range.x, position_range.y, amount)


func set_icon(value: Texture) -> void:
	icon = value
	if not is_inside_tree():
		yield(self, "ready")
	_icon_node.texture = icon


func set_type(value: int) -> void:
	type = value
	texture = _types[type]
