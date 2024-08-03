extends Control
@onready var save_menu = $"."
@onready var nine_patch_rect = $NinePatchRect
@onready var label = $NinePatchRect/Label
@onready var code = $NinePatchRect/code
@onready var paste = $NinePatchRect/code/Paste
@onready var copy = $NinePatchRect/code/Copy
@onready var save_load = $"NinePatchRect/save-load"
@onready var load = $"NinePatchRect/save-load/Load"
@onready var save = $"NinePatchRect/save-load/Save"
@onready var nine_patch_rect2 = $NinePatchRect/NinePatchRect
#@onready var save_code = $NinePatchRect/NinePatchRect/save_code
@onready var save_code = $NinePatchRect/NinePatchRect/TextEdit

@onready var back = $NinePatchRect/Back
@onready var display_message = $NinePatchRect/display_message
@onready var message_timer = $NinePatchRect/display_message/message_timer

var save_code_full : String
var save_code_cut : String
var code_valid : bool

func _on_paste_pressed():
	save_code_full = DisplayServer.clipboard_get()
#	if save_code_full.length() > 200:
#		save_code_cut = save_code_full.substr(0, 200) + "....."
#		save_code.text = save_code_cut
#	else:
	save_code.text = save_code_full
	display_message.text = "Pasted!"
	display_message.set_visible(true)
	message_timer.start(3)

func _on_copy_pressed():
	var clipboard = save_code_full
	if clipboard != "" && clipboard != ".....":
		DisplayServer.clipboard_set(clipboard)
	display_message.text = "Copied!"
	display_message.set_visible(true)
	message_timer.start(3)


func _on_load_pressed():
	var loaded = StaticData.load_data(save_code.text)
	if loaded:
		display_message.text = "Loaded!"
		display_message.set_visible(true)
		message_timer.start(3)
		if get_parent().get_parent().get_parent().name == "Hub World":
			get_parent().get_parent().get_parent().get_node("Player").loaded_data()
		if get_parent().get_parent().get_parent().get_parent().name == "Hub World":
			get_parent().get_parent().get_parent().get_parent().get_node("Player").loaded_data()
	else:
		error()


func _on_save_pressed():
	var save_code_full = StaticData.save_data()
	if save_code_full:
#		if save_code_new.length() > 200:
#			save_code_cut = save_code_new.substr(0, 200) + "....."
#			save_code.text = save_code_cut
#			save_code_full = save_code_new
#		else:
		save_code.text = save_code_full
		display_message.text = "Saved! Make sure to save this code for later!"
		display_message.set_visible(true)
		message_timer.start(3)
	else:
		error()


func _on_back_pressed():
	if get_parent().name == "Main Menu": get_parent().focus_gained()
	else: get_parent().get_parent().focus_gained()

func error():
	display_message.text = "Error!"
	display_message.set_visible(true)
	message_timer.start(3)

func _on_message_timer_timeout():
	message_timer.stop()
	display_message.set_visible(false)
	display_message.text = ""
