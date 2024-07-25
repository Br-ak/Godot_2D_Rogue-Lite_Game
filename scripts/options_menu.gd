class_name SettingsTabContainer
extends Control
@onready var tab_container = $AspectRatioContainer/TabContainer as TabContainer
@onready var CONTROLS_v_box_container = $AspectRatioContainer/TabContainer/Controls/ScrollContainer/VBoxContainer
@onready var keybindList = StaticData.keybindList
@onready var master_volume = $"AspectRatioContainer/TabContainer/Sound/GridContainer/Master Volume"
@onready var master_volume_slider = $"AspectRatioContainer/TabContainer/Sound/GridContainer/Master Volume Slider"
@onready var music_volume = $"AspectRatioContainer/TabContainer/Sound/GridContainer/Music Volume"
@onready var music_volume_slider = $"AspectRatioContainer/TabContainer/Sound/GridContainer/Music Volume Slider"
@onready var sfx_volume = $"AspectRatioContainer/TabContainer/Sound/GridContainer/Sfx Volume"
@onready var sfx_volume_slider = $"AspectRatioContainer/TabContainer/Sound/GridContainer/Sfx Volume Slider"
@onready var menu_volume = $"AspectRatioContainer/TabContainer/Sound/GridContainer/Menu Volume"
@onready var menu_volume_slider = $"AspectRatioContainer/TabContainer/Sound/GridContainer/Menu Volume Slider"
@onready var grid_container = $AspectRatioContainer/TabContainer/Sound/GridContainer

@onready var audio_manager = self.get_tree().get_root().get_node("AudioManager")

var sound_settings = []



# Called when the node enters the scene tree for the first time.
func _ready():
	create_Controls_HSeparator()
	populate_Keybinds()
	populate_sound_settings()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_exit_button_pressed():
	## check for unsaved changes
	get_parent().focus_gained()
	#get_tree().change_scene_to_file("res://tscn/main_menu.tscn")

func _on_apply_button_pressed():
	
	if tab_container.current_tab == 2: # sound settings
		var new_sound_settings = []
		var data = StaticData.sound_settings["sound_settings"]
		var key
		var changes = false
		for node in grid_container.get_children():
			if node is HSlider:
				key = node.get_meta("key")
				new_sound_settings.append(node.value)
				if node.value != data[key]["assigned_volume"]:
					changes = true
					print("node.value: ", node.value)
					StaticData.save_sound_data(key, node.value)
		if changes:
			audio_manager.change_audio_level(new_sound_settings)

func create_Controls_HSeparator():
	const separator = preload("res://tscn/controls_separator.tscn")
	var new_separator = separator.instantiate()
	CONTROLS_v_box_container.call("add_child", new_separator)

func populate_sound_settings():
	var data = StaticData.sound_settings["sound_settings"]
	sound_settings = []
	for key in data:
		if grid_container.has_node(data[key]["name"]):
			var sound_slider = grid_container.get_node(data[key]["name"])
			if sound_slider is HSlider:
				sound_slider.value = data[key]["assigned_volume"]
				sound_settings.append(data[key]["assigned_volume"])

func populate_Keybinds():
	const hotkey_rebind_button = preload("res://tscn/hotkey_rebind_button.tscn")
	var data = StaticData.keybinds["keybinds"]
	for key in keybindList:
		if key != "attack_primary":
			var new_hotkey_rebind_button = hotkey_rebind_button.instantiate()
			new_hotkey_rebind_button.action_name = key
			new_hotkey_rebind_button.action_name_formatted = data[key]["name"]
			new_hotkey_rebind_button.current_keybind = data[key]["assigned_key"]
			CONTROLS_v_box_container.call("add_child", new_hotkey_rebind_button)
