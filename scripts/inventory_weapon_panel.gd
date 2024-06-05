extends Control

@onready var v_box_container = $"."
@onready var label = $Label
@onready var weapon_image = $TextureButton
@onready var panel = $Panel
@onready var grid_container = $Panel/GridContainer
@onready var inventory_menu = get_node("../../../..")

var weapon_image_path
var newImage
var temp_image_path = "res://assets/GUNS_V1.00/V1.00/PNG/GUN_01_[square_frame]_01_V1.00.png"
var socket_count
const panel_socket = preload("res://tscn/panel_socket.tscn")
var title
var attack_number


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
		new_panel_socket.texture_path = "res://assets/GUNS_V1.00/V1.00/PNG/test_socket.png"
		new_panel_socket.socket_type = "WEAPON"
		grid_container.add_child(new_panel_socket)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func init_panel(socket_count):
	pass

func update_weapon_stats(data):
	if inventory_menu.has_method("update_weapon_stats"):
		inventory_menu.update_weapon_stats(data, attack_number)
