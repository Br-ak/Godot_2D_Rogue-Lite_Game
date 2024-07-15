extends Control
@onready var data = StaticData.keybinds["keybinds"]
@onready var keybindList = StaticData.keybindList
@onready var audio_manager = self.get_tree().get_root().get_node("AudioManager")
var music_data = ["Music"]
@onready var options_menu = $"Options Menu"
@onready var main_menu_selections = $"Main Menu Selections"
var root
func _ready():
	options_menu._ready()
	audio_manager.play_music("BGM_menu", music_data)
	
	_bind_user_keys()

func _on_start_button_pressed():
	root = get_parent().get_parent()
	for node in self.get_children():
		node.set_visible(false)
	if root.name == "Hub World" && root.has_method("start_game"):
		root.start_game()
	#get_tree().change_scene_to_file("res://tscn/game.tscn")

func _on_option_button_pressed():
	main_menu_selections.set_visible(false)
	options_menu.set_visible(true)
	#get_tree().change_scene_to_file("res://tscn/options_menu.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

func focus_gained():
	for node in self.get_children():
		if node.name != "Main Menu Selections":
			node.set_visible(false)
	main_menu_selections.set_visible(true)

func _bind_user_keys():
	for key in keybindList:
		if key != "attack_primary":
			InputMap.action_erase_events(key)
			var assigned_key = OS.find_keycode_from_string(data[key]["assigned_key"])
			var new_assigned_key = InputEventKey.new()
			new_assigned_key.set_physical_keycode(assigned_key)
			InputMap.action_add_event(key, new_assigned_key)
