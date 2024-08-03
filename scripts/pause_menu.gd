extends Control
@onready var pause_menu = $"."
@onready var h_box_container = $"AspectRatioContainer/Pause Menu Selections/HBoxContainer"
@onready var confirm = $"AspectRatioContainer/Pause Menu Selections/Confirm"
@onready var options_menu = $"AspectRatioContainer/Options Menu"
@onready var pause_menu_selections = $"AspectRatioContainer/Pause Menu Selections"
@onready var save_menu = $AspectRatioContainer/save_menu
@onready var save_load = $"AspectRatioContainer/Pause Menu Selections/save-load"


func _on_resume_pressed():
	pause_menu.set_visible(false)
	Engine.time_scale = 1
	confirm.set_visible(false)
	h_box_container.set_visible(false)
	options_menu.set_visible(false)
	if get_parent().get_parent().get_node("Player"):
		get_parent().get_parent().get_node("Player").playable = true

func _on_quit_pressed():
	confirm.set_visible(true)
	h_box_container.set_visible(true)

func _on_yes_pressed():
	get_tree().quit()

func _on_no_pressed():
	confirm.set_visible(false)
	h_box_container.set_visible(false)


func _on_options_pressed():
	pause_menu_selections.set_visible(false)
	options_menu.tab_container.set_current_tab(0)

	options_menu.set_visible(true)

func focus_gained():
#	for node in self.get_children():
#		if node.name != "Pause Menu Selections":
#			node.set_visible(false)
	options_menu.set_visible(false)
	save_menu.set_visible(false)
	pause_menu_selections.set_visible(true)


func _on_saveload_pressed():
	options_menu.set_visible(false)
	pause_menu_selections.set_visible(false)
	save_menu.set_visible(true)
