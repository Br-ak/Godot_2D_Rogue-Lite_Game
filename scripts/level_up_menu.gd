extends Control
@onready var exit = $AspectRatioContainer/VBoxContainer/Exit
@onready var level_up_menu = $"."

@onready var title_a = $AspectRatioContainer/VBoxContainer/GridContainer/TitleA
@onready var title_b = $AspectRatioContainer/VBoxContainer/GridContainer/TitleB
@onready var title_c = $AspectRatioContainer/VBoxContainer/GridContainer/TitleC

@onready var desc_a = $AspectRatioContainer/VBoxContainer/GridContainer/DescA
@onready var desc_b = $AspectRatioContainer/VBoxContainer/GridContainer/DescB
@onready var desc_c = $AspectRatioContainer/VBoxContainer/GridContainer/DescC

@onready var icon_a = $AspectRatioContainer/VBoxContainer/GridContainer/IconA
@onready var icon_b = $AspectRatioContainer/VBoxContainer/GridContainer/IconB
@onready var icon_c = $AspectRatioContainer/VBoxContainer/GridContainer/IconC

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_exit_pressed():
	level_up_menu.set_visible(false)
	Engine.time_scale = 1

func _on_reroll_button_pressed():
	var data = StaticData.itemData["upgrades"]["upgrade2"]
	title_a.text = data["name"]
	desc_a.text = data["description"]
	var newIcon = load(data["icon"])
	icon_a.set_texture_normal(newIcon)
