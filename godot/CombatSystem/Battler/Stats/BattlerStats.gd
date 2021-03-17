# Stores and manages the battler's base stats like health, energy, and base damage.
extends Resource
class_name BattlerStats

signal health_depleted
signal health_changed(old_value, new_value)
signal energy_changed(old_value, new_value)

const UPGRADABLE_STATS = [
	"max_health", "max_energy", "attack", "defense", "speed", "hit_chance", "evasion"
]

export var max_health := 100.0
export var max_energy := 6

export var base_attack := 10.0 setget set_base_attack
export var base_defense := 10.0 setget set_base_defense
export var base_speed := 70.0 setget set_base_speed
export var base_hit_chance := 100.0 setget set_base_hit_chance
export var base_evasion := 0.0 setget set_base_evasion

export var weaknesses := []
export (Types.Elements) var affinity: int = Types.Elements.NONE

var health := max_health setget set_health
var energy := 0 setget set_energy

var attack := base_attack
var defense := base_defense
var speed := base_speed
var hit_chance := base_hit_chance
var evasion := base_evasion

# Modifiers has a list of modifiers for each property in `UPGRADABLE_STATS`.
# The value of a modifier can be any float.
var _modifiers := {}


# Initializes keys in the modifiers dict, ensuring they all exist.
func _init() -> void:
	for stat in UPGRADABLE_STATS:
		_modifiers[stat] = {}


func reinitialize() -> void:
	set_health(max_health)


# Adds a modifier that affects the stat with the given `stat_name` and returns its unique key.
func add_modifier(stat_name: String, value: float) -> int:
	assert(stat_name in UPGRADABLE_STATS, "Trying to add a modifier to a nonexistent stat.")
	var id := _generate_unique_id(stat_name)
	_modifiers[stat_name][id] = value
	_recalculate_and_update(stat_name)
	return id


func remove_modifier(stat_name: String, id: int) -> void:
	assert(id in _modifiers[stat_name], "Id %s not found in %s" % [id, _modifiers[stat_name]])
	_modifiers[stat_name].erase(id)
	_recalculate_and_update(stat_name)


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
	_recalculate_and_update("attack")


func set_base_defense(value: float) -> void:
	base_defense = value
	_recalculate_and_update("defense")


func set_base_speed(value: float) -> void:
	base_speed = value
	_recalculate_and_update("speed")


func set_base_hit_chance(value: float) -> void:
	base_hit_chance = value
	_recalculate_and_update("hit_chance")


func set_base_evasion(value: float) -> void:
	base_evasion = value
	_recalculate_and_update("evasion")


# Calculates the final value of a single stat, its based value with all modifiers applied.
func _recalculate_and_update(stat: String) -> void:
	var value: float = get("base_" + stat)
	var modifiers: Array = _modifiers[stat].values()
	for modifier in modifiers:
		value += modifier
	value = max(value, 0.0)
	set(stat, value)


func _generate_unique_id(stat_name: String) -> int:
	var keys: Array = _modifiers[stat_name].keys()
	if keys.empty():
		return 0
	else:
		return keys.back() + 1
