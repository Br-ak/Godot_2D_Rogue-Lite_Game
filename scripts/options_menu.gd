class_name SettingsTabContainer
extends Control
@onready var tab_container = $AspectRatioContainer/TabContainer as TabContainer
@onready var CONTROLS_v_box_container = $AspectRatioContainer/TabContainer/Controls/ScrollContainer/VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	create_Controls_HSeparator()
	populate_Keybinds()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_exit_button_pressed():
	## check for unsaved changes
	get_tree().change_scene_to_file("res://tscn/main_menu.tscn")

func _on_apply_button_pressed():
	pass # Replace with function body.

func create_Controls_HSeparator():
	const separator = preload("res://tscn/controls_separator.tscn")
	var new_separator = separator.instantiate()
	CONTROLS_v_box_container.call("add_child", new_separator)

func populate_Keybinds():
	const hotkey_rebind_button = preload("res://tscn/hotkey_rebind_button.tscn")
	var data = StaticData.keybinds["keybinds"]
	for key in data:
		var new_hotkey_rebind_button = hotkey_rebind_button.instantiate()
		new_hotkey_rebind_button.action_name = key
		new_hotkey_rebind_button.action_name_formatted = data[key]["name"]
		new_hotkey_rebind_button.current_keybind = data[key]["assigned_key"]
		CONTROLS_v_box_container.call("add_child", new_hotkey_rebind_button)
