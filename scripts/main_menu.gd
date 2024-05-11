extends Control
@onready var data = StaticData.keybinds["keybinds"]
@onready var keybindList = StaticData.keybindList

func _ready():
	_bind_user_keys()

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://tscn/game.tscn")

func _on_option_button_pressed():
	get_tree().change_scene_to_file("res://tscn/options_menu.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

func _bind_user_keys():
	for key in keybindList:
		if key != "attack_primary":
			InputMap.action_erase_events(key)
			var assigned_key = OS.find_keycode_from_string(data[key]["assigned_key"])
			var new_assigned_key = InputEventKey.new()
			new_assigned_key.set_physical_keycode(assigned_key)
			InputMap.action_add_event(key, new_assigned_key)
