extends Control
@onready var menu = $"."
@onready var confirm = $Confirm
@onready var h_box_container = $HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_stats_pressed():
	pass # Replace with function body.


func _on_menu_pressed():
	confirm.set_visible(true)
	h_box_container.set_visible(true)


func _on_yes_pressed():
	get_tree().change_scene_to_file("res://tscn/main_menu.tscn")
	Engine.time_scale = 1


func _on_no_pressed():
	confirm.set_visible(false)
	h_box_container.set_visible(false)
