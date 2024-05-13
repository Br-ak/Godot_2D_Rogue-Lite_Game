class_name UpgradePanel
extends VBoxContainer
@export var title : String = ""
@export var description : String = ""
@export var icon_path : String = ""
@export var key : String = ""

@onready var upgrade_panel = $"."
@onready var title_label = $Title
@onready var desc_text = $Desc
@onready var icon_button = $Icon

@onready var data = StaticData.itemData["upgrades"][key]

# Called when the node enters the scene tree for the first time.
func _ready():
	title_label.text = title
	desc_text.text = description
	var newIcon = load(data["icon"])
	icon_button.set_texture_normal(newIcon)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
