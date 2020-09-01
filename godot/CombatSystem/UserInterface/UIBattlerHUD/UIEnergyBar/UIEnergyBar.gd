# Bar representing energy points. Each point is an instance of UIEnergyPoint.
extends HBoxContainer

const UIEnergyPoint: PackedScene = preload("UIEnergyPoint.tscn")

var max_value := 0
var value := 0 setget set_value


func setup(max_energy: int, energy: int) -> void:
	max_value = max_energy
	value = energy
	for i in max_value:
		var energy_point: TextureRect = UIEnergyPoint.instance()
		add_child(energy_point)


func set_value(amount: int) -> void:
	var old_value := value
	value = min(amount, max_value)
	var difference := value - old_value
	if difference > 0:
		for i in range(old_value, value):
			get_child(i).appear()
	elif difference < 0:
		for i in range(old_value, value):
			get_child(i).disappear()
