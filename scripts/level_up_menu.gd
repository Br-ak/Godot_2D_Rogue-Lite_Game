extends Control
@onready var exit = $AspectRatioContainer/VBoxContainer2/Exit
@onready var level_up_menu = $"."

@onready var upgrade_container = $AspectRatioContainer/VBoxContainer2/HBoxContainer
#@onready var data = StaticData.upgrades["upgrades"]

var upgrade_count = 0
var upgrade_panel_count = 3
var displayed_upgrades = []
var prev_displayed_upgrades = []
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#on_open()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func on_open():
	pass
#	for key in data:
#		upgrade_count += 1
#	init_upgrade_panel()

func init_upgrade_panel():
	pass
#	const upgrade_panel = preload("res://tscn/upgrade_panel.tscn")
#	while displayed_upgrades.size() != upgrade_panel_count:
#		var rand_upgrade = str(randi() % upgrade_count + 1)
#		var upgrade_key = "upgrade" + rand_upgrade
#
#		while displayed_upgrades.has(upgrade_key) || prev_displayed_upgrades.has(upgrade_key): # dont allow duplicates
#			rand_upgrade = str(randi() % upgrade_count + 1)
#			upgrade_key = "upgrade" + rand_upgrade
#
#		var new_upgrade_panel = upgrade_panel.instantiate()
#		new_upgrade_panel.key = upgrade_key
#		new_upgrade_panel.title = data[upgrade_key]["name"]
#		new_upgrade_panel.description = data[upgrade_key]["description"]
#		new_upgrade_panel.icon_path = data[upgrade_key]["image"]
#
#		displayed_upgrades.append(upgrade_key)
#		upgrade_container.call("add_child", new_upgrade_panel)
#	prev_displayed_upgrades = displayed_upgrades
#	displayed_upgrades = []

func _on_exit_pressed():
	level_up_menu.set_visible(false)
	Engine.time_scale = 1

func _on_reroll_button_pressed():
	
	for object in upgrade_container.get_children():
		if object is UpgradePanel:
			object.queue_free()
	init_upgrade_panel()
