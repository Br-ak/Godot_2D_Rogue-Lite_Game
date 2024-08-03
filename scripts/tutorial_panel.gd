extends Control
@onready var control = $"."
@onready var h_box_container = $HBoxContainer
@onready var tutorial_visual = $HBoxContainer/TextureRect
@onready var tutorial_text = $HBoxContainer/Label

var image_path := ""
var description_text := "..."
var texture

func init():
	if image_path != "":
		texture = load(image_path)
	if description_text:
		tutorial_text.text = description_text
