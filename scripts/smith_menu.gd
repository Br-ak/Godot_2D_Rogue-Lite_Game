extends Control

@onready var data = StaticData.weapons["weapons"]
@onready var smith_menu = $"."
@onready var nine_patch_rect = $NinePatchRect
@onready var menu_title = $NinePatchRect/menu_title
@onready var grid_container = $NinePatchRect/ScrollContainer/GridContainer
@onready var player = get_parent().get_parent().get_node("Player")
@onready var weapon_swap_hud = get_parent().get_node("Hud").weapon_swap
@onready var hub = get_parent().get_parent()
@onready var confirmation_box = $"confirmation box"
@onready var confimation_title = $"confirmation box/confimation_title"
@onready var confirm_selections = $"confirmation box/confirm_selections"
@onready var yes = $"confirmation box/confirm_selections/yes"
@onready var no = $"confirmation box/confirm_selections/no"
@onready var currency_notice = $"confirmation box/currency_notice"
@onready var currency_image = $"confirmation box/currency_notice/currency_image"
@onready var cost = $"confirmation box/currency_notice/cost"

var temp_listing_info = []
var listings = []

# Called when the node enters the scene tree for the first time.
func _ready():
	init_listings()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func init_listings():
	const menu_listing = preload("res://tscn/menu_listing.tscn")
	menu_title.text = "Smiffy's Inventory"
	for weapon in data:
		var new_menu_listing = menu_listing.instantiate()
		var listing_info = [data[weapon]["name"], data[weapon]["listing_cost"], data[weapon]["description"], "Smith", weapon] # name, cost, description, seller, key
		grid_container.call("add_child", new_menu_listing)
		listings.append(data[weapon]["name"])
		new_menu_listing.icon_path = data[weapon]["listing_icon_path"]
		new_menu_listing.listing_info = listing_info
		new_menu_listing.init_listing()

#handle listing button pressed
func button_pressed(listing_info):
	#listing exists
	if listing_info[0] in listings:
		temp_listing_info = listing_info
		#player has enough money
		if player.player_coins >= int(temp_listing_info[1]):
			init_confirmation_menu()
		else:
			# error message
			pass

func _on_texture_button_pressed():
	smith_menu.set_visible(false)
	hub.interacting_with = ""
	hub.smith_interactable_pressed()

func init_confirmation_menu():
	var image_path = load("res://assets/visual/upgrades/currency_coin.png")
	currency_image.set_texture(image_path)
	cost.text = "- " + str(temp_listing_info[1]) # cost
	
	nine_patch_rect.set_modulate(Color(1, 1, 1, 0.25)) # fade background menu
	confirmation_box.set_visible(true)

func _on_yes_pressed():
	for node in grid_container.get_children():
		if node.listing_info[0] == temp_listing_info[0]:
			node.sold()
		else:
			node.button_pressed = false
	player.weapon_add(temp_listing_info[0])
	player.weapons_purchased.append(temp_listing_info[0])
	player.player_coins -= int(temp_listing_info[1])
	weapon_swap_hud.init()
	nine_patch_rect.set_modulate(Color(1, 1, 1, 1))
	confirmation_box.set_visible(false)

func _on_no_pressed():
	# nothing happens
	for node in grid_container.get_children():
		node.button_pressed = false
	nine_patch_rect.set_modulate(Color(1, 1, 1, 1))
	confirmation_box.set_visible(false)
