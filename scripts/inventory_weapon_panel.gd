extends Control

@onready var v_box_container = $"."
@onready var label = $Label
@onready var weapon_image = $TextureButton
@onready var panel = $Panel
@onready var grid_container = $Panel/GridContainer
@onready var inventory_menu = get_node("../../../..")

var weapon_name
var weapon_image_path
var newImage
var temp_image_path = "res://assets/GUNS_V1.00/V1.00/PNG/GUN_01_[square_frame]_01_V1.00.png"
var socket_count
const panel_socket = preload("res://tscn/panel_socket.tscn")
var title
var attack_number
var upgrade_list = []

# Called when the node enters the scene tree for the first time.
func _ready():
	if weapon_image_path:
		newImage = load(weapon_image_path)
		weapon_image.set_texture_normal(newImage)
		print(weapon_image)
	if title:
		label.text = title
	
	for i in range(1, socket_count + 1):
		var new_panel_socket = panel_socket.instantiate()
		#new_panel_socket.texture_path = "res://assets/GUNS_V1.00/V1.00/PNG/test_socket.png"
		new_panel_socket.socket_type = "WEAPON"
		new_panel_socket.socket_location = attack_number
		grid_container.add_child(new_panel_socket)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func init_panel(_socket_count):
	pass

func update_weapon_stats(data, method):
	print("data: ", data)
	if method == "add":
		upgrade_list.append(data)
	elif method == "remove" && upgrade_list.has(data):
		upgrade_list.erase(data)
	elif data == "refresh" && method == "refresh":
		pass
	print("data: ",data)
	
	#pass upgrades to weapon to reinitalize and calculate
	if inventory_menu.has_method("update_weapon_stats"):
			inventory_menu.update_weapon_stats(upgrade_list, attack_number)
