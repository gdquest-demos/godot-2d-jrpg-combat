# Stores and manages the battler's base stats like health, energy, and base damage.
extends Resource
class_name BattlerStats

signal health_depleted
signal health_changed(old_value, new_value)
signal energy_changed(old_value, new_value)

const UPGRADABLE_STATS = ["max_health", "max_energy", "attack", "speed"]

export var max_health := 100.0
export var max_energy := 6

export var base_attack := 10.0 setget set_base_attack
export var base_speed := 70.0 setget set_base_speed

export var weaknesses := []

var health := max_health setget set_health
var energy := 0 setget set_energy

var attack := base_attack
var speed := base_speed

# Modifiers has a list of modifiers for each property in `UPGRADABLE_STATS`. Each modifier is a dict that
# requires a key named `value`. The value of a modifier can be any float.
var _modifiers := {}


# Initializes keys in the modifiers dict, ensuring they all exist.
func _init() -> void:
	for stat in UPGRADABLE_STATS:
		_modifiers[stat] = {}


# Adds a modifier that affects the stat with the given `stat_name` and returns its unique key.
func add_modifier(stat_name: String, value: float) -> int:
	assert(stat_name in UPGRADABLE_STATS, "Trying to add a modifier to a nonexistent stat.")
	var id := _generate_unique_id(stat_name)
	_modifiers[stat_name][id] = {value = value}
	_calculate(stat_name)
	return id


func set_health(value: float) -> void:
	var health_previous := health
	health = clamp(value, 0.0, max_health)
	emit_signal("health_changed", health_previous, health)
	if is_equal_approx(health, 0.0):
		emit_signal("health_depleted")


func set_energy(value: int) -> void:
	var energy_previous := energy
	energy = int(clamp(value, 0.0, max_energy))
	emit_signal("energy_changed", energy_previous, energy)


func set_base_attack(value: float) -> void:
	base_attack = value
	attack = _calculate("attack")


func set_base_speed(value: float) -> void:
	base_speed = value
	speed = _calculate("speed")


# Calculates the final value of a single stat, its based value with all modifiers applied.
func _calculate(stat: String) -> float:
	var value: float = get("base_" + stat)
	for modifier in _modifiers[stat]:
		value += modifier
	value = max(value, 0.0)
	return value


func _generate_unique_id(stat_name: String) -> int:
	var last_id: int = _modifiers[stat_name].keys().back()
	return 0 if last_id == null else last_id + 1
