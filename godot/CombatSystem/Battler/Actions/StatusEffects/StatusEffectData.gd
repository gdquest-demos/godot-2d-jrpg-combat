class_name StatusEffectData
extends Resource

export var effect := ""
export var duration_seconds := 20.0
export var effect_power := 20
export var effect_rate := 0.5
export var is_ticking := false
export var ticking_interval := 4.0
export var ticking_damage := 3


func calculate_total_damage() -> int:
	var damage := 0
	if is_ticking:
		damage += int(duration_seconds / ticking_interval * ticking_damage)
	return damage
