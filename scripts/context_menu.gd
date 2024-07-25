extends Control

@onready var control = $"."
@onready var nine_patch_rect = $NinePatchRect
@onready var v_box_container = $NinePatchRect/VBoxContainer
@onready var button_1 = $NinePatchRect/VBoxContainer/Button
@onready var button_2 = $NinePatchRect/VBoxContainer/Button2
@onready var button_3 = $NinePatchRect/VBoxContainer/Button3
@onready var hub = get_parent().get_parent()
@onready var label = $NinePatchRect/Label

var button1_text := "Talk"
var button2_text := "Buy/Sell"
var button3_text := "Exit"

func init():
	label.text = ""
	button_1.text = button1_text
	button_2.text = button2_text
	button_3.text = button3_text
	button_1.set_visible(true)
	button_2.set_visible(true)
	button_3.set_visible(true)

# talk option
func _on_button_pressed():
	if hub.has_method("context_talk_button"):
		hub.context_talk_button()

# buy/sell/upgrade
func _on_button_2_pressed():
	if hub.has_method("context_merchant_button"):
		hub.context_merchant_button()


func _on_button_3_pressed():
	if hub.has_method("context_exit_button"):
		hub.context_exit_button()
