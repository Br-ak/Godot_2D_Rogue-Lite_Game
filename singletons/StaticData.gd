extends Node

var itemData = {}
var keybinds = {}

var upgrades_file_path = "res://resources/upgrades.json"
var keybinds_file_path = "res://resources/keybinds.json"

func _ready():
	itemData = load_json_file(upgrades_file_path)
	keybinds = load_json_file(keybinds_file_path)

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
