extends Control

@onready var weapons = StaticData.weapons["weapons"]
@onready var player_upgrades = StaticData.player_upgrades["upgrades"]
@onready var shop_menu = $"."
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
var menu_info = [] # 0: title, 1:listing type, 2:vendor
var new_cost

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#init_listings()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func init_listings():
	for node in grid_container.get_children():
		node.queue_free()
	const menu_listing = preload("res://tscn/menu_listing.tscn")
	menu_title.text = menu_info[0]
	if menu_info[1] == "weapons":
		for weapon in weapons:
			var new_menu_listing = menu_listing.instantiate()
			var listing_info = [weapons[weapon]["name"], weapons[weapon]["listing_cost"], weapons[weapon]["description"], "Smith", weapon] # name, cost, description, seller, key
			grid_container.call("add_child", new_menu_listing)
			listings.append(weapons[weapon]["name"])
			new_menu_listing.icon_path = weapons[weapon]["listing_icon_path"]
			new_menu_listing.listing_info = listing_info
			new_menu_listing.init_listing()
	elif menu_info[1] == "player upgrades":
		for player_upgrade in player_upgrades:
			var new_menu_listing = menu_listing.instantiate()
			# name, cost, description, seller, key, current amount
			var pips_active = player_upgrades[player_upgrade]["current_level"]
			
			var listing_info = [player_upgrades[player_upgrade]["name"], player_upgrades[player_upgrade]["listing_cost"], 
				player_upgrades[player_upgrade]["description"], "Seer", player_upgrade, pips_active] 
			grid_container.call("add_child", new_menu_listing)
			listings.append(player_upgrades[player_upgrade]["name"])
			new_menu_listing.icon_path = player_upgrades[player_upgrade]["listing_icon_path"]
			new_menu_listing.listing_info = listing_info
			new_menu_listing.pips_active = pips_active
			new_menu_listing.init_listing()

#handle listing button pressed
func button_pressed(listing_info, num):
	#listing exists
	if listing_info[0] in listings:
		temp_listing_info = listing_info
		if menu_info[1] == "weapons":
			#player has enough money
			if player.player_coins >= int(temp_listing_info[1]):
				init_confirmation_menu()
			else:
				# error message
				pass
		elif menu_info[1] == "player upgrades":
			var index = str(temp_listing_info[5] + 1)
			var cost = int(player_upgrades[str(temp_listing_info[4])]["listing_cost"][index])
			if player.player_crystal >= cost:
				init_confirmation_menu()
			else:
				# error message
				pass

func _on_texture_button_pressed():
	shop_menu.set_visible(false)
	hub.interacting_with = ""
	if menu_info[2] == "Smith":
		hub.smith_interactable_pressed()
	if menu_info[2] == "Seer":
		hub.seer_interactable_pressed()

func init_confirmation_menu():
	var image_path
	if menu_info[1] == "weapons":
		image_path = load("res://assets/visual/upgrades/currency_coin.png")
		currency_image.set_texture(image_path)
		cost.text = "- " + str(temp_listing_info[1]) # cost
		nine_patch_rect.set_modulate(Color(1, 1, 1, 0.25)) # fade background menu
		confirmation_box.set_visible(true)
	elif menu_info[1] == "player upgrades":
		image_path = load("res://assets/visual/upgrades/currency_mana.png")
		currency_image.set_texture(image_path)
		var costs = temp_listing_info[1]
		new_cost = costs[str(int(temp_listing_info[5]) + 1)]
		cost.text = "- " + str(new_cost)
		nine_patch_rect.set_modulate(Color(1, 1, 1, 0.25)) # fade background menu
		confirmation_box.set_visible(true)

func _on_yes_pressed():
	for node in grid_container.get_children():
		if node.listing_info[0] == temp_listing_info[0]:
			node.sold()
		else:
			node.button_pressed = false
	if menu_info[1] == "weapons":
		player.weapon_add(temp_listing_info[0], 1)
		StaticData.player_info.equipped_weapon = temp_listing_info[0]
		player.weapons_purchased.append(temp_listing_info[0])
		StaticData.player_info.weapons_purchased.append(temp_listing_info[0])
		player.player_coins -= int(temp_listing_info[1])
		StaticData.player_info.currency.coin -= int(temp_listing_info[1])
		weapon_swap_hud.init()
		hub.weapon_equipped = true
	elif menu_info[1] == "player upgrades":
		player.stat_upgrade(temp_listing_info[4])
		player.skills_purchased.append(temp_listing_info[0])
		StaticData.player_info.skills_purchased.append(temp_listing_info[0])
		player.player_crystal -= int(new_cost)
		StaticData.player_info.currency.crystal -= int(new_cost)
	
	nine_patch_rect.set_modulate(Color(1, 1, 1, 1))
	confirmation_box.set_visible(false)
	init_listings()

func _on_no_pressed():
	# nothing happens
	for node in grid_container.get_children():
		node.button_pressed = false
	nine_patch_rect.set_modulate(Color(1, 1, 1, 1))
	confirmation_box.set_visible(false)
