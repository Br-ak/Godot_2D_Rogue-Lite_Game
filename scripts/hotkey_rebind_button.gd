class_name HotkeyRebindButton
extends Control

@onready var label = $HBoxContainer/Label as Label
@onready var button = $HBoxContainer/Button as Button

@export var action_name : String = ""
@export var action_name_formatted : String = ""
@export var current_keybind : String = ""
@onready var data = StaticData.keybinds["keybinds"]

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_unhandled_key_input(false)
	set_info()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func set_info():
	label.text = action_name_formatted
	button.text = current_keybind

func set_text_for_key():
	var action_events = InputMap.action_get_events(action_name)
	var action_event = action_events[0]
	var action_keycode
	if action_event is InputEventMouseButton:
		action_keycode = action_event.button_index
	elif action_event is InputEventKey:
		action_keycode = OS.get_keycode_string(action_event.physical_keycode)
	
	button.text = "%s" % action_keycode

func _on_button_toggled(button_pressed):
	if button_pressed:
		button.text = "Press any key..."
		set_process_unhandled_key_input(button_pressed)
		
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = false
				i.set_process_unhandled_input(false)
				
	else:
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = true
				i.set_process_unhandled_input(false)
		
		set_text_for_key()

func _unhandled_key_input(event):
	rebind_action_key(event)
	button.button_pressed = false

func rebind_action_key(event):
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, event)
	
	StaticData.save_keybind_data(action_name, event.as_text())
	set_process_unhandled_key_input(false)
	set_text_for_key()
	set_info()

#class_name HotkeyRebindButton
#extends Control
#
#@onready var label = $HBoxContainer/Label as Label
#@onready var button_1 = $HBoxContainer/Button as Button
#@onready var button_2 = $HBoxContainer/Button2 as Button
#
#@export var action_name : String = ""
#@export var action_name_formatted : String = ""
#@export var current_keybind : String = ""
#@export var alternate_key : String = ""
#
#var data = StaticData.keybinds["keybinds"]
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#	set_process_unhandled_key_input(false)
#	set_info()
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):
#	pass
#
#func set_info():
#	label.text = action_name_formatted
#	button_1.text = current_keybind
#	if alternate_key != "":
#		button_2.text = alternate_key
#	else:
#		button_2.text = "Not Bound"
#
#func set_text_for_key(button):
#	var action_events = InputMap.action_get_events(action_name)
#
#	var action_event = action_events[0]
#	if button == button_2 && action_events.size() > 1:
#		action_event = action_events[1]
#	var action_keycode
#	if action_event is InputEventMouseButton:
#		action_keycode = action_event.button_index
#	elif action_event is InputEventKey:
#		action_keycode = OS.get_keycode_string(action_event.physical_keycode)
#
#	button.text = "%s" % action_keycode
#
#func _on_button_toggled(button_pressed):
#	print(button_pressed)
#	if button_pressed:
#		button_1.text = "Press any key..."
#		set_process_unhandled_key_input(button_pressed)
#
#		for i in get_tree().get_nodes_in_group("hotkey_button"):
#			if i.action_name != self.action_name:
#				i.button_1.toggle_mode = false
#				i.set_process_unhandled_input(false)
#
#	else:
#		for i in get_tree().get_nodes_in_group("hotkey_button"):
#			if i.action_name != self.action_name:
#				i.button_1.toggle_mode = true
#				i.set_process_unhandled_input(false)
#
#		set_text_for_key(button_1)
#
#func _on_button_2_toggled(button_pressed):
#	if button_pressed:
#		button_2.text = "Press any key..."
#		set_process_unhandled_key_input(button_pressed)
#
#		for i in get_tree().get_nodes_in_group("hotkey_button"):
#			if i.action_name != self.action_name:
#				i.button_2.toggle_mode = false
#				i.set_process_unhandled_input(false)
#
#	else:
#		for i in get_tree().get_nodes_in_group("hotkey_button"):
#			if i.action_name != self.action_name:
#				i.button_2.toggle_mode = true
#				i.set_process_unhandled_input(false)
#
#		set_text_for_key(button_2)
#
#func _unhandled_key_input(event):
#	if button_1.button_pressed == true:
#		rebind_action_key(event, button_1)
#		button_1.button_pressed = false
#	elif button_2.button_pressed == true:
#		rebind_action_key(event, button_2)
#		button_2.button_pressed = false
#
#func rebind_action_key(event, button):
#	print(InputMap.action_get_events(action_name))
#	print(action_name)
#	if button == button_1:
#
#		var events = InputMap.action_get_events(action_name)
#		if events.size() > 1: ## action has more than 1 keybind already
#			var event2 = events[1] as InputEventKey
#			InputMap.action_erase_events(action_name)
#			InputMap.action_add_event(action_name, event)
#			InputMap.action_add_event(action_name, event2)
#		else:
#			InputMap.action_erase_events(action_name)
#			InputMap.action_add_event(action_name, event)
#	elif button == button_2:
#		var events = InputMap.action_get_events(action_name)
#		var event1 = events[0] as InputEventKey
#		InputMap.action_erase_events(action_name)
#		InputMap.action_add_event(action_name, event1)
#		InputMap.action_add_event(action_name, event)
#
#
#	StaticData.save_data(action_name, event.as_text())
#	set_process_unhandled_key_input(false)
#	set_text_for_key(button_1)
#	set_text_for_key(button_2)
#	set_info()
#	print(InputMap.action_get_events(action_name))
