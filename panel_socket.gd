extends TextureRect
class_name Draggable

@onready var socket = $"."
@onready var weapon_inventory = get_node("../../..")
@onready var item = $Item

var data = []
var upgrade = []
var socket_type
var socket_location

var dropped_on_target := false
var has_item := false
var texture_path
var texture_empty = preload("res://assets/GUNS_V1.00/V1.00/PNG/test_socket.png")
var texture_filled = preload("res://assets/GUNS_V1.00/V1.00/PNG/GUN_01_[square_frame]_01_V1.00.png")
const panel_socket = preload("res://tscn/panel_socket.tscn")
var icon_texture

func _ready():
	
	add_to_group("DRAGGABLE")
	socket.set_texture(texture_empty)
	item.set_texture(null)
	self.has_item = false
	if self.socket_type == "INVENTORY":
		if texture_path:
			icon_texture = load(texture_path)
		else:
			icon_texture = texture_filled
		item.set_texture(icon_texture)
		self.has_item = true

func _get_drag_data(at_position):
	if not dropped_on_target && has_item:
		set_drag_preview(get_preview_control())
		return self

func get_preview_control() -> Control:
	var preview = TextureRect.new()
	preview.set_texture(icon_texture)
	var modulate = Color(1, 1, 1, 0.5)
	preview.set_modulate(modulate)
	preview.set_rotation(.1)
	return preview

func _can_drop_data(at_position, data) -> bool:
	var can_drop: bool = data is Node and data.is_in_group("DRAGGABLE")
	return can_drop

func _drop_data(at_position, data):
	if data.item != null:
		if self.has_item:
			print("item already here")
		else:
			if texture_path:
				icon_texture = load(texture_path)
			self.item.set_texture(icon_texture)
			self.has_item = true
			self.swap_data(data)
			
			
			print("_drop_data: ", upgrade)
			if data.socket_location == self.socket_location:
				pass
			elif data.socket_type == "WEAPON":
				data.weapon_inventory.update_weapon_stats(upgrade, "remove")
			if self.socket_type == "WEAPON" && weapon_inventory.has_method("update_weapon_stats"):
				weapon_inventory.update_weapon_stats(upgrade, "add")
			data.remove_item()


func remove_item():
	self.has_item = false
	item.set_texture(null)
	for key in data:
		self.key = null
	self.upgrade = null

func swap_data(data_to_swap):
	self.upgrade = data_to_swap.upgrade
	self.texture_path = data_to_swap.texture_path
	icon_texture = load(self.texture_path)
	self.item.set_texture(icon_texture)
	for key in data:
		self.key = data_to_swap.key
