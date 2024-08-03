extends Control

@onready var chest_menu = $"."
@onready var nine_patch_rect = $NinePatchRect
@onready var menu_title = $NinePatchRect/menu_title
@onready var texture_button = $NinePatchRect/TextureButton
@onready var scroll_container = $NinePatchRect/ScrollContainer
@onready var grid_container = $NinePatchRect/ScrollContainer/GridContainer
@onready var info_box = $"info box"
@onready var title = $"info box/title"
@onready var selections = $"info box/selections"
@onready var yes = $"info box/selections/yes"
@onready var no = $"info box/selections/no"

@onready var weapon_container = $"info box/VBoxContainer"
@onready var weapon_icon = $"info box/icon"
@onready var weapon_name = $"info box/VBoxContainer/name"
@onready var weapon_desc = $"info box/VBoxContainer/desc"
@onready var weapon_attacks = $"info box/VBoxContainer/attacks"

@onready var player = get_parent().get_parent().get_node("Player")
@onready var weapon_swap_hud = get_parent().get_node("Hud").weapon_swap
@onready var data = StaticData.weapons["weapons"]
@onready var hub = self.get_parent().get_parent()

var temp_listing_info = []
var listings = []
var selected_weapon
var slot := 1

# Called when the node enters the scene tree for the first time.
func _ready():
	init_listings()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func init_listings():
	for node in grid_container.get_children():
		node.queue_free()
	const menu_listing = preload("res://tscn/menu_listing.tscn")
	menu_title.text = "My Stuff"
	for weapon in data:
		var new_menu_listing = menu_listing.instantiate()
		var listing_info = [data[weapon]["name"], "Select", data[weapon]["description"], "Chest", weapon] # name, cost, description, seller, key
		grid_container.call("add_child", new_menu_listing)
		listings.append(data[weapon]["name"])
		new_menu_listing.icon_path = data[weapon]["listing_icon_path"]
		new_menu_listing.listing_info = listing_info
		new_menu_listing.init_listing()
		if data[weapon]["name"] in player.weapons_purchased && player.equipped_weapon.WEAPON_NAME != weapon || data[weapon]["name"] in StaticData.player_info.weapons_purchased:
			new_menu_listing.button.set_visible(true)
			new_menu_listing.button_2.set_visible(true)
			new_menu_listing.button.text = "Equip1"
			new_menu_listing.button_2.text = "Equip2"
		else:
			new_menu_listing.button.set_visible(false)
			new_menu_listing.button_2.set_visible(false)
			new_menu_listing.texture_rect.set_modulate(Color(1, 1, 1, 0.25))

#handle listing button pressed
func button_pressed(listing_info, num):
	#listing exists
	if listing_info[0] in listings:
		slot = num
		temp_listing_info = listing_info
		init_info_menu(temp_listing_info[4])
	init_listings()

func _on_texture_button_pressed():
	chest_menu.set_visible(false)
	player.playable = true
	get_parent().get_parent().can_interact = true

func init_info_menu(key):
	nine_patch_rect.set_modulate(Color(1, 1, 1, 0.25)) # fade background menu
	info_box.set_visible(true)
	
	var texture = load(data[key]["listing_icon_path"])
	weapon_icon.set_texture(texture)
	weapon_name.text = data[key]["name"]
	weapon_desc.text = data[key]["description"]
	

func _on_yes_pressed():
	for node in grid_container.get_children():
		if node.listing_info[0] == temp_listing_info[0]:
			node.button.set_visible(false)
			selected_weapon = node
			hub.weapon_equipped = true
		else:
			node.button_pressed = false
	# reinit weapon button visibility
	for node in grid_container.get_children():
		if node != selected_weapon && node.listing_info[0] in player.weapons_purchased:
			node.button.set_visible(true)
		elif node != selected_weapon && node.listing_info[0] in StaticData.player_info.weapons_purchased:
			node.button.set_visible(true)
	
	player.weapon_add(temp_listing_info[0], slot)
	if slot == 1: StaticData.player_info.equipped_weapon = temp_listing_info[0]
	elif slot == 2: StaticData.player_info.holstered_weapon = temp_listing_info[0]
	player.weapons_purchased.append(temp_listing_info[0])
	StaticData.player_info.weapons_purchased.append(temp_listing_info[0])
	player.player_coins -= int(temp_listing_info[1])
	
	weapon_swap_hud.init()
	nine_patch_rect.set_modulate(Color(1, 1, 1, 1))
	info_box.set_visible(false)
	init_listings()

func _on_no_pressed():
	# nothing happens
	for node in grid_container.get_children():
		node.button_pressed = false
	nine_patch_rect.set_modulate(Color(1, 1, 1, 1))
	info_box.set_visible(false)
