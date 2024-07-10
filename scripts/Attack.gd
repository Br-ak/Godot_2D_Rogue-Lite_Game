class_name Attack

#attack variables
var weapon_stat_list = ["attack_damage", "attack_wait", "attack_hits", "attack_type", "attack_origin", "attack_pattern", "attack_pierce", 
"attack_projectile_count", "attack_projectile_offset", "attack_reset_time", "attack_projectile_speed", "attack_range", "attack_base_damage",
"attack_damage_increase", "attack_damage_multiplier", "attack_reset_time_multiplier", "WEAPON_NAME", "ATTACK_NUMBER", "attack_projectile_count_incerase"]
#add all changes to res://singletons/StaticData.gd


var attack_damage : float
var attack_base_damage : float
var attack_wait : float
var attack_hits := 1
var attack_type : String # can be Melee, Ranged, etc...
var attack_origin: float # needed for branching/splitting attacks
var attack_pattern := "BASIC" # can be BASIC, FORK, SPREAD, SPIRAL, MIRROR...
var attack_pierce := 0
var attack_projectile_count_incerase := 0
var attack_projectile_count := 1
var attack_projectile_offset := 10
var attack_reset_time := 1
var attack_reset_time_multiplier := 1.0
var attack_projectile_speed := 500
var attack_range := 300
var attack_damage_increase := 0
var attack_damage_multiplier := 1.0

var WEAPON_NAME 
var ATTACK_NUMBER := 0

#unused currently
var knockback_force: float

func _ready():
	update_attack_damage()

func update_attack_damage():
	attack_damage = (attack_base_damage + attack_damage_increase) * attack_damage_multiplier
