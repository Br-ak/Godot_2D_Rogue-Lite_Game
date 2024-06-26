extends Control
@onready var exit = $AspectRatioContainer/VBoxContainer2/Exit
@onready var level_up_menu = $"."
@onready var upgrade_container = $AspectRatioContainer/VBoxContainer2/HBoxContainer
@onready var upgrade_data = StaticData.upgrades["upgrades"]
@onready var label = $AspectRatioContainer/VBoxContainer2/Label
@onready var player = get_parent().get_parent().get_node("World").get_node("Player")
@onready var error_message = $"AspectRatioContainer/VBoxContainer2/Error Message"

var upgrade_count = 0
var upgrade_panel_count = 3
var displayed_upgrades = []
var prev_displayed_upgrades = []
var obtained_upgrades = []

# Called when the node enters the scene tree for the first time.
func _ready():
	on_open()
	init_upgrade_panel()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func on_open():
	label.text = "Upgrades To Redeem: " + str(player.level_ups)
	upgrade_count = 0
	for key in upgrade_data:
		upgrade_count += 1

func init_upgrade_panel():
	const upgrade_panel = preload("res://tscn/upgrade_panel.tscn")
	while displayed_upgrades.size() != upgrade_panel_count:
		var upgrade_keys = upgrade_data.keys()
		var upgrade_key = upgrade_keys[randi() % upgrade_count]
		
		while displayed_upgrades.has(upgrade_key) || prev_displayed_upgrades.has(upgrade_key): # dont allow duplicates
			upgrade_keys = upgrade_data.keys()
			upgrade_key = upgrade_keys[randi() % upgrade_count]
		
		var new_upgrade_panel = upgrade_panel.instantiate()
		new_upgrade_panel.set("key", upgrade_key)
		new_upgrade_panel.set("title", upgrade_data[upgrade_key]["name"])
		new_upgrade_panel.set("description", upgrade_data[upgrade_key]["description"])
		new_upgrade_panel.set("icon_path", upgrade_data[upgrade_key]["image"])
		displayed_upgrades.append(upgrade_key)
		upgrade_container.call("add_child", new_upgrade_panel)
	prev_displayed_upgrades = displayed_upgrades
	displayed_upgrades = []

func _on_exit_pressed():
	error_message.set_visible(false)
	level_up_menu.set_visible(false)
	Engine.time_scale = 1

func _on_reroll_button_pressed():
	error_message.set_visible(false)
	for object in upgrade_container.get_children():
		if object is UpgradePanel:
			object.queue_free()
	init_upgrade_panel()

func show_error_message(error):
	if !error_message.is_visible():
		error_message.set_visible(true)
	error_message.text = error
