extends Control
@onready var inventory_menu = $"."
@onready var aspect_ratio_container = $AspectRatioContainer
@onready var v_box_container = $AspectRatioContainer/VBoxContainer
@onready var label = $"AspectRatioContainer/VBoxContainer/Label"
@onready var h_box_container = $AspectRatioContainer/VBoxContainer/HBoxContainer
@onready var exit = $AspectRatioContainer/VBoxContainer/Exit
@onready var label_2 = $AspectRatioContainer/VBoxContainer/Label2

@onready var data = StaticData.weapons["weapons"]
@onready var player = get_parent().get_parent().get_node("World").get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	#on_open()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func on_open():
	init_weapon_panels()

func init_weapon_panels():
	print("init_weapon_panels()")
	var equipped_weapon_key = player.equipped_weapon.WEAPON_NAME
	label_2.text = data[equipped_weapon_key]["name"]
	var attack1_base_upgrade_slots = -1
	var attack2_base_upgrade_slots = -1
	const weapon_panel_object = preload("res://tscn/inventory_weapon_panel.tscn")
	for obj in data[equipped_weapon_key]:
		if obj == "attack1_base_upgrade_slots":
			attack1_base_upgrade_slots = data[equipped_weapon_key][obj]
			var attack1_weapon_panel = weapon_panel_object.instantiate()
			attack1_weapon_panel.title = data[equipped_weapon_key]["attacks"]["attack1"]["name"]
			attack1_weapon_panel.weapon_image_path = data[equipped_weapon_key]["asset_path"]
			attack1_weapon_panel.socket_count = data[equipped_weapon_key][obj]
			h_box_container.call("add_child", attack1_weapon_panel)
		elif obj == "attack2_base_upgrade_slots":
			attack2_base_upgrade_slots = data[equipped_weapon_key][obj]
			var attack2_weapon_panel = weapon_panel_object.instantiate()
			attack2_weapon_panel.title = data[equipped_weapon_key]["attacks"]["attack2"]["name"]
			attack2_weapon_panel.weapon_image_path = data[equipped_weapon_key]["asset_path"]
			attack2_weapon_panel.socket_count = data[equipped_weapon_key][obj]
			h_box_container.call("add_child", attack2_weapon_panel)



func _on_exit_pressed():
	inventory_menu.set_visible(false)
	Engine.time_scale = 1
