class_name Attack

#attack variables
var attack_damage : float
var attack_wait : float
var attack_hitcount := 1
var attack_type : String # can be Melee, Ranged, etc...

var attack_origin: float # needed for branching/splitting attacks
var attack_pattern := "BASIC" # can be BASIC, FORK, SPREAD, SPIRAL, MIRROR...


#unused currently
var knockback_force: float


func custom_function():
	pass
