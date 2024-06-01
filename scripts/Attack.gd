class_name Attack

#attack variables
var weapon_stat_list = ["attack_damage", "attack_wait", "attack_hits", "attack_type", "attack_origin", "attack_pattern", "attack_pierce", 
"attack_projectile_count", "attack_projectile_offset", "attack_reset_time", "attack_projectile_speed", "attack_range"]

var attack_damage : float
var attack_wait : float
var attack_hits := 1
var attack_type : String # can be Melee, Ranged, etc...
var attack_origin: float # needed for branching/splitting attacks
var attack_pattern := "BASIC" # can be BASIC, FORK, SPREAD, SPIRAL, MIRROR...
var attack_pierce := 0
var attack_projectile_count := 1
var attack_projectile_offset := 10
var attack_reset_time := 1
var attack_projectile_speed : int
var attack_range := 1200

#unused currently
var knockback_force: float


func custom_function():
	pass
