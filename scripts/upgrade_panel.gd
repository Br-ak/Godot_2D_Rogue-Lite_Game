class_name UpgradePanel
extends VBoxContainer
@export var title : String = ""
@export var description : String = ""
@export var icon_path : String = ""

@onready var key
@onready var upgrade_panel = $"."
@onready var title_label = $Title
@onready var desc_text = $Desc
@onready var icon_button = $Icon
@onready var canvas_layer = get_node("../../../../..")
@onready var inventory = canvas_layer.get_node("Inventory Menu")
@onready var level_up_menu = get_node("../../../..")
@onready var player = inventory.get_parent().get_parent().get_node("World").get_node("Player")
@onready var data = StaticData.upgrades["upgrades"][key]

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("TOOLTIP_ENABLED")
	title_label.text = title
	desc_text.text = description
	var newIcon = load(data["image"])
	icon_button.set_texture_normal(newIcon)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_button_pressed():
	if player.level_ups > 0:
		inventory.add_upgrade_to_inventory(key)
		player.level_ups -= 1
		level_up_menu._on_exit_pressed()
	else:
		pass
		level_up_menu.show_error_message("No Upgrdes Available")
