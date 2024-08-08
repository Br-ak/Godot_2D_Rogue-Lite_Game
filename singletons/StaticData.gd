extends Node

var player_info = {
	location = null,
	equipped_weapon = null,
	holstered_weapon = null,
	weapons_purchased = [],
	weapon_upgrades = [],
	skills_purchased = [],
	currency = {
		crystal = 500,
		coin = 2000,
	},
	stat_upgrades = {
		perma_upgrade_health = 0,
		perma_upgrade_speed = 0,
		perma_upgrade_attack_speed = 0,
		perma_upgrade_follower_attack_speed = 0,
		perma_upgrade_follower_damage = 0,
	},
}


var upgrades = {}
var keybinds = {}
var sound_settings = {}
var weapons = {}
var dialogue = {}
var player_upgrades = {}
var keybindList = ["attack_primary", "ui_up", "ui_left", "ui_down", "ui_right", "debug_inventory", "weapon_swap", "player_interact", "debug_level_up"]
var upgrades_file_path = "res://resources/upgrades.json"
var keybinds_file_path = "res://resources/keybinds.json"
var weapons_file_path = "res://resources/weapons.json"
var sound_settings_file_path = "res://resources/sound_settings.json"
var dialogue_file_path = "res://resources/dialogue.json"
var player_upgrades_file_path = "res://resources/player_perma_upgrades.json"

var weapon_stat_list = ["attack_damage", "attack_wait", "attack_hits", "attack_type", "attack_origin", "attack_pattern", "attack_pierce", 
"attack_projectile_count", "attack_projectile_offset", "attack_reset_time", "attack_projectile_speed", "attack_range", "attack_base_damage",
"attack_damage_increase", "attack_damage_multiplier", "attack_reset_time_multiplier", "WEAPON_NAME", "ATTACK_NUMBER", "attack_projectile_count_incerase"]
var save_code_temp
func _ready():
	save_code_temp = save_data()
	#save_code_temp = "eyJjdXJyZW5jeSI6eyJjb2luIjoxMCwiY3J5c3RhbCI6NTAwfSwiZXF1aXBwZWRfd2VhcG9uIjpudWxsLCJob2xzdGVyZWRfd2VhcG9uIjpudWxsLCJsb2NhdGlvbiI6bnVsbCwic2tpbGxzX3B1cmNoYXNlZCI6e30sInN0YXRfdXBncmFkZXMiOnsicGVybWFfdXBncmFkZV9hdHRhY2tfc3BlZWQiOjIsInBlcm1hX3VwZ3JhZGVfZm9sbG93ZXJfYXR0YWNrX3NwZWVkIjozLCJwZXJtYV91cGdyYWRlX2ZvbGxvd2VyX2RhbWFnZSI6NCwicGVybWFfdXBncmFkZV9oZWFsdGgiOjUwMCwicGVybWFfdXBncmFkZV9zcGVlZCI6NTAwfSwid2VhcG9uX3VwZ3JhZGVzIjp7fSwid2VhcG9uc19wdXJjaGFzZWQiOnt9fQ=="
	#print("Save Code: ", save_code)

	load_data(save_code_temp)
	upgrades = load_json_file(upgrades_file_path)
	keybinds = load_json_file(keybinds_file_path)
	weapons = load_json_file(weapons_file_path)
	sound_settings = load_json_file(sound_settings_file_path)
	dialogue = load_json_file(dialogue_file_path)
	player_upgrades = load_json_file(player_upgrades_file_path)

func load_json_file(filePath : String):
	if FileAccess.file_exists(filePath):
		var dataFile = FileAccess.open(filePath, FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		
		if parsedResult is Dictionary:
			return parsedResult
		else:
			print("Error Reading File")
	else:
		print("File Not Found")

func save_keybind_data(key, value):
	keybinds["keybinds"][key]["assigned_key"] = value
	var json = JSON.stringify(keybinds, "\t")
	var file = FileAccess.open(keybinds_file_path, FileAccess.WRITE)
	file.store_line(json)
	file.close()

func save_sound_data(key, value):
	sound_settings["sound_settings"][key]["assigned_volume"] = value
	var json = JSON.stringify(sound_settings, "\t")
	var file = FileAccess.open(sound_settings_file_path, FileAccess.WRITE)
	file.store_line(json)
	file.close()

func update_upgrade_level(key, value):
#	print("key: ", key)
#	print("value: ", value)
	var player_upgrades_data = StaticData.player_upgrades["upgrades"]
	player_upgrades_data[key]["current_level"] = value
	var json = JSON.stringify(player_upgrades, "\t")
	var file = FileAccess.open(player_upgrades_file_path, FileAccess.WRITE)
	file.store_line(json)
	file.close()

func save_data():
	return Marshalls.raw_to_base64(JSON.stringify(player_info).to_utf8_buffer())

func load_data(save_code: String):
	var byte_array = Marshalls.base64_to_raw(save_code)
	var json_string = byte_array.get_string_from_utf8()
	var parsed_data = parse_json(save_code)
	
	if parsed_data != null:
		for key in player_info.keys():
			if parsed_data.has(key):
				player_info[key] = parsed_data[key]
		return true
	else:
		return false

func parse_json(save_code: String):
	return JSON.parse_string(Marshalls.base64_to_raw(save_code).get_string_from_utf8())
