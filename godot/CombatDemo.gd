extends Node2D


onready var active_turn_queue := $ActiveTurnQueue
onready var ui_turn_bar := $UI/UITurnBar

func _ready() -> void:
	ui_turn_bar.setup(active_turn_queue.battlers)
