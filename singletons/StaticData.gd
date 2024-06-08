extends Node

var upgrades = {}
var keybinds = {}
var weapons = {}
var keybindList = ["attack_primary", "ui_up", "ui_left", "ui_down", "ui_right"]
var upgrades_file_path = "res://resources/upgrades.json"
var keybinds_file_path = "res://resources/keybinds.json"
var weapons_file_path = "res://resources/weapons.json"
var weapon_stat_list = ["attack_damage", "attack_wait", "attack_hits", "attack_type", "attack_origin", "attack_pattern", "attack_pierce", 
"attack_projectile_count", "attack_projectile_offset", "attack_reset_time", "attack_projectile_speed", "attack_range", "attack_base_damage",
"attack_damage_increase", "attack_damage_multiplier"]

func _ready():
	upgrades = load_json_file(upgrades_file_path)
	keybinds = load_json_file(keybinds_file_path)
	weapons = load_json_file(weapons_file_path)

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

func save_data(key, value):
	keybinds["keybinds"][key]["assigned_key"] = value
	var json = JSON.stringify(keybinds, "\t")
	var file = FileAccess.open(keybinds_file_path, FileAccess.WRITE)
	file.store_line(json)
	file.close()
