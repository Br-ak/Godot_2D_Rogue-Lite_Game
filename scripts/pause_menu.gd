extends Control
@onready var pause_menu = $"."
@onready var h_box_container = $"AspectRatioContainer/Pause Menu Selections/HBoxContainer"
@onready var confirm = $"AspectRatioContainer/Pause Menu Selections/Confirm"
@onready var options_menu = $"AspectRatioContainer/Options Menu"
@onready var pause_menu_selections = $"AspectRatioContainer/Pause Menu Selections"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_resume_pressed():
	pause_menu.set_visible(false)
	Engine.time_scale = 1
	confirm.set_visible(false)
	h_box_container.set_visible(false)

func _on_quit_pressed():
	confirm.set_visible(true)
	h_box_container.set_visible(true)

func _on_yes_pressed():
	get_tree().change_scene_to_file("res://tscn/main_menu.tscn")
	Engine.time_scale = 1

func _on_no_pressed():
	confirm.set_visible(false)
	h_box_container.set_visible(false)


func _on_options_pressed():
	pause_menu_selections.set_visible(false)
	options_menu.set_visible(true)

func focus_gained():
#	for node in self.get_children():
#		if node.name != "Pause Menu Selections":
#			node.set_visible(false)
	options_menu.set_visible(false)
	pause_menu_selections.set_visible(true)
