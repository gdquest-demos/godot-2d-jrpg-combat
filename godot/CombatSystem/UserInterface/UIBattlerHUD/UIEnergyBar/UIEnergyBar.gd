# Bar representing energy points. Each point is an instance of UIEnergyPoint.
extends HBoxContainer

const UIEnergyPoint: PackedScene = preload("UIEnergyPoint.tscn")

var max_value := 0
var value := 0 setget set_value

var selected_count := 0 setget set_selected_count


func setup(max_energy: int, energy: int) -> void:
	max_value = max_energy
	value = energy
	for i in max_value:
		var energy_point: TextureRect = UIEnergyPoint.instance()
		add_child(energy_point)


func set_value(amount: int) -> void:
	var old_value := value
	value = int(clamp(amount, 0.0, max_value))
	if value > old_value:
		for i in range(old_value, value):
			get_child(i).appear()
	else:
		for i in range(old_value, value, -1):
			get_child(i - 1).disappear()


func set_selected_count(amount: int) -> void:
	var old_value := selected_count
	selected_count = int(clamp(amount, 0.0, max_value))
	if selected_count > old_value:
		for i in range(old_value, selected_count):
			get_child(i).select()
	else:
		for i in range(old_value, selected_count, -1):
			get_child(i - 1).deselect()
