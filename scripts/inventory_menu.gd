extends Control
@onready var inventory_menu = $"."
@onready var aspect_ratio_container = $AspectRatioContainer
@onready var v_box_container = $AspectRatioContainer/VBoxContainer
@onready var label = $"AspectRatioContainer/VBoxContainer/Label"
@onready var h_box_container = $AspectRatioContainer/VBoxContainer/HBoxContainer
@onready var exit = $AspectRatioContainer/VBoxContainer/Exit
@onready var label_2 = $AspectRatioContainer/VBoxContainer/Label2
@onready var inventory_grid_container = $AspectRatioContainer2/Panel/GridContainer

@onready var data = StaticData.weapons["weapons"]
#@onready var upgrades = StaticData.upgrades["upgrades"]
@onready var player = get_parent().get_parent().get_node("World").get_node("Player")

const panel_socket = preload("res://tscn/panel_socket.tscn")
const weapon_panel_object = preload("res://tscn/inventory_weapon_panel.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	init_inventory_panel()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func on_open():
	init_weapon_panels()

func init_weapon_panels():
	var equipped_weapon_key = player.equipped_weapon.WEAPON_NAME
	label_2.text = data[equipped_weapon_key]["name"]
	var attack1_base_upgrade_slots = -1
	var attack2_base_upgrade_slots = -1

	for obj in data[equipped_weapon_key]:
		if obj == "attack1_base_upgrade_slots":
			attack1_base_upgrade_slots = data[equipped_weapon_key][obj]
			var attack1_weapon_panel = weapon_panel_object.instantiate()
			attack1_weapon_panel.title = data[equipped_weapon_key]["attacks"]["attack1"]["name"]
			attack1_weapon_panel.weapon_image_path = data[equipped_weapon_key]["asset_path"]
			attack1_weapon_panel.socket_count = data[equipped_weapon_key][obj]
			attack1_weapon_panel.attack_number = 1
			h_box_container.call("add_child", attack1_weapon_panel)
		elif obj == "attack2_base_upgrade_slots":
			attack2_base_upgrade_slots = data[equipped_weapon_key][obj]
			var attack2_weapon_panel = weapon_panel_object.instantiate()
			attack2_weapon_panel.title = data[equipped_weapon_key]["attacks"]["attack2"]["name"]
			attack2_weapon_panel.weapon_image_path = data[equipped_weapon_key]["asset_path"]
			attack2_weapon_panel.socket_count = data[equipped_weapon_key][obj]
			attack2_weapon_panel.attack_number = 2
			h_box_container.call("add_child", attack2_weapon_panel)

func init_inventory_panel():
	for i in range (0, 14):
		var new_panel_socket = panel_socket.instantiate()
		new_panel_socket.upgrade = "attack_fork"
		new_panel_socket.texture_path = "res://assets/GUNS_V1.00/V1.00/PNG/test_socket.png"
		new_panel_socket.socket_type = "INVENTORY"
		inventory_grid_container.add_child(new_panel_socket)

func _on_exit_pressed():
	inventory_menu.set_visible(false)
	Engine.time_scale = 1

func update_weapon_stats(data, attack_num):
	print("im really high up")
	if player.equipped_weapon.has_method("update_attacks"):
		player.equipped_weapon.update_attacks(data, attack_num)
