extends Control
@onready var inventory_menu = $"."
@onready var aspect_ratio_container = $"Weapon Panel Container"
@onready var v_box_container = $"Weapon Panel Container/VBoxContainer"
@onready var label = $"Weapon Panel Container/VBoxContainer/Label"
@onready var weapon_panel_container = $"Weapon Panel Container/VBoxContainer/HBoxContainer"
@onready var exit = $"Weapon Panel Container/VBoxContainer/Exit"
@onready var label_2 = $"Weapon Panel Container/VBoxContainer/Label2"
@onready var inventory_grid_container = $"Inventory Panel Container/Panel/GridContainer"

@onready var data = StaticData.weapons["weapons"]
@onready var upgrades = StaticData.upgrades["upgrades"]
@onready var player = get_parent().get_parent().get_node("World").get_node("Player")

const panel_socket = preload("res://tscn/panel_socket.tscn")
const weapon_panel_object = preload("res://tscn/inventory_weapon_panel.tscn")

var equipped_weapon_name
var holstered_weapon_name


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
	equipped_weapon_name = player.equipped_weapon.WEAPON_NAME
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
			attack1_weapon_panel.weapon_name = equipped_weapon_key
			weapon_panel_container.call("add_child", attack1_weapon_panel)
		elif obj == "attack2_base_upgrade_slots":
			attack2_base_upgrade_slots = data[equipped_weapon_key][obj]
			var attack2_weapon_panel = weapon_panel_object.instantiate()
			attack2_weapon_panel.title = data[equipped_weapon_key]["attacks"]["attack2"]["name"]
			attack2_weapon_panel.weapon_image_path = data[equipped_weapon_key]["asset_path"]
			attack2_weapon_panel.socket_count = data[equipped_weapon_key][obj]
			attack2_weapon_panel.attack_number = 2
			attack2_weapon_panel.weapon_name = equipped_weapon_key
			weapon_panel_container.call("add_child", attack2_weapon_panel)

func init_inventory_panel():
	var new_panel_socket = panel_socket.instantiate()
	new_panel_socket.upgrade = "attack_fork"
	new_panel_socket.texture_path = "res://assets/GUNS_V1.00/V1.00/PNG/test_fork.png"
	new_panel_socket.socket_type = "INVENTORY"
	new_panel_socket.socket_location = 0
	new_panel_socket.tooltip_desc = "Fork Gem: Forks Projectile"
	inventory_grid_container.add_child(new_panel_socket)
	new_panel_socket = panel_socket.instantiate()
	new_panel_socket.upgrade = "damage_increase"
	new_panel_socket.texture_path = "res://assets/GUNS_V1.00/V1.00/PNG/test_damage.png"
	new_panel_socket.socket_type = "INVENTORY"
	new_panel_socket.socket_location = 0
	new_panel_socket.tooltip_desc = "Damage Gem: Increases Damage"
	inventory_grid_container.add_child(new_panel_socket)
	new_panel_socket = panel_socket.instantiate()
	new_panel_socket.upgrade = "attack_pierce"
	new_panel_socket.texture_path = "res://assets/GUNS_V1.00/V1.00/PNG/test_pierce.png"
	new_panel_socket.socket_type = "INVENTORY"
	new_panel_socket.socket_location = 0
	new_panel_socket.tooltip_desc = "Pierce Gem: Increases Pierce Amount"
	inventory_grid_container.add_child(new_panel_socket)

func _on_exit_pressed():
	inventory_menu.set_visible(false)
	Engine.time_scale = 1

func update_weapon_stats(upgrade_list, attack_num):
	if player.equipped_weapon.has_method("update_attacks"):
		player.equipped_weapon.update_attacks(upgrade_list, attack_num)

func add_upgrade_to_inventory(key):
	print("adding upgrade to inventory key: ", key)
	#var new_upgrade = upgrades[key]
	var new_panel_socket = panel_socket.instantiate()
	new_panel_socket.upgrade = key
	new_panel_socket.texture_path = upgrades[key]["image"]
	new_panel_socket.socket_type = "INVENTORY"
	new_panel_socket.socket_location = 0
	new_panel_socket.tooltip_desc = upgrades[key]["description"]
	inventory_grid_container.add_child(new_panel_socket)

func swap_weapons():
	# remove (hide) current inventory panel(s)
	for weapon_panel_node in weapon_panel_container.get_children():
		if weapon_panel_node is VBoxContainer && equipped_weapon_name == weapon_panel_node.weapon_name:
			weapon_panel_node.set_visible(false)
	#swap weapon names
	var temp = equipped_weapon_name
	equipped_weapon_name = holstered_weapon_name
	holstered_weapon_name = temp
	var weapon_already_init = false
	for weapon_panel_node in weapon_panel_container.get_children():
		if weapon_panel_node is VBoxContainer && equipped_weapon_name == weapon_panel_node.weapon_name:
			weapon_already_init = true
			weapon_panel_node.set_visible(true)
			weapon_panel_node.update_weapon_stats("refresh", "refresh")
	if !weapon_already_init:
		init_weapon_panels()
