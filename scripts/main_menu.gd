extends Control
@onready var data = StaticData.keybinds["keybinds"]
@onready var keybindList = StaticData.keybindList
@onready var audio_manager = self.get_tree().get_root().get_node("AudioManager")
var music_data = ["Music"]
@onready var options_menu = $"Options Menu"
@onready var main_menu_selections = $"Main Menu Selections"
var root


@onready var blur_background = get_parent().get_node("blur_background")
@onready var fadeout := false
@onready var shader_value = blur_background.material.get_shader_parameter("value")
@onready var fade_speed = 0.0005

var start_pressed := false
func _ready():
	options_menu._ready()
	audio_manager.play_music("BGM_menu", music_data)
	
	_bind_user_keys()

func _physics_process(delta):
	if start_pressed:
		shader_value -= fade_speed
	shader_value = clamp(shader_value, 0.0, 0.1)
	blur_background.material.set_shader_parameter("value", shader_value)
	if shader_value <= 0:
		close_menu()

func close_menu():
	root = get_parent().get_parent()
	for node in self.get_children():
		node.set_visible(false)
	blur_background.set_visible(false)
	if root.name == "Hub World" && root.has_method("start_game"):
		root.start_game()

func _on_start_button_pressed():
	start_pressed = true
	#fade_timer.start(0.1)
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



