extends Resource
class_name Upgrade

@export var base_pps : float = 0;
@export var base_cost : int = 0;
@export var label : String = "none";
@export var description : String = "none";
@export var pps_multiplier := 1.0
@export var unlock_threshold := 0; # reveal when player has earned this much total

var pps : float:
	get: return base_pps * level * pps_multiplier # when pps is called returns this

var level : int = 1;
var scaling_factor : float = 1.15;

func buy() -> void:
	level += 1
	
func apply_multiplier(mult: float) -> void:
	pps_multiplier *= mult

func is_unlocked(total_earned: int) -> bool:
	return total_earned >= unlock_threshold

func get_price() -> int:
	return ceili(base_cost * (scaling_factor ** level));
