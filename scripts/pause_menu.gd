extends Control
@onready var pause_menu = $"."
@onready var confirm = $Confirm
@onready var h_box_container = $HBoxContainer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_resume_pressed():
	pause_menu.set_visible(false)
	Engine.time_scale = 1

func _on_quit_pressed():
	confirm.set_visible(true)
	h_box_container.set_visible(true)

func _on_yes_pressed():
	get_tree().change_scene_to_file("res://tscn/main_menu.tscn")
	Engine.time_scale = 1

func _on_no_pressed():
	confirm.set_visible(false)
	h_box_container.set_visible(false)
