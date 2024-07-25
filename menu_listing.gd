extends Control

@onready var menu_listing = $"."
@onready var texture_rect_2 = $TextureRect2
@onready var texture_rect = $TextureRect
@onready var button = $TextureRect/Button
@onready var upgrade_pips = $TextureRect/Button/upgrade_pips
@onready var player = get_parent().get_parent().get_parent().get_parent().player
@onready var label = $TextureRect/Label
@onready var desc = $TextureRect/desc
@onready var texture_rect_3 = $TextureRect/TextureRect3
@onready var sold_icon = $TextureRect3
@onready var player_upgrades = StaticData.player_upgrades["upgrades"]

var icon_path
var button_pressed := false 
var listing_info = [] # name, cost, description, seller, key
var currency_path
var currency_texture
var pips_active := 0
var pip_empty = preload("res://assets/visual/upgrades/upgrade_pip_empty.png")
var pip_filled = preload("res://assets/visual/upgrades/upgrade_pip_filled.png")

@onready var pip_1 = $TextureRect/Button/upgrade_pips/TextureRect
@onready var pip_2 = $TextureRect/Button/upgrade_pips/TextureRect2
@onready var pip_3 = $TextureRect/Button/upgrade_pips/TextureRect3
@onready var pip_4 = $TextureRect/Button/upgrade_pips/TextureRect4
@onready var pip_5 = $TextureRect/Button/upgrade_pips/TextureRect5
var pips = []


func init_listing():
	pips = [pip_1, pip_2, pip_3, pip_4, pip_5]
	if icon_path:
		var texture = load(icon_path)
		texture_rect.set_texture(texture)
	if listing_info:
		label.text = listing_info[0]
		if listing_info[0].length() > 18:
			label.add_theme_font_size_override("font_size", 14)
		if listing_info[3] == "Smith": 
			currency_path = "res://assets/visual/upgrades/currency_coin.png"
			button.text = listing_info[1]
			if listing_info[0] in player.weapons_purchased:
				button.set_visible(false) 
				sold_icon.set_visible(true)
		elif listing_info[3] == "Seer": 
			currency_path = "res://assets/visual/upgrades/currency_mana.png"
			
			for i in range(pips_active):
				pips[i].set_texture(pip_filled)
				pips[i].set_modulate(Color(1, 1, 1, 1))
			button.text = str(player_upgrades[listing_info[4]]["listing_cost"][str(pips_active + 1)])
			upgrade_pips.set_visible(true)
		
		if currency_path:
			currency_texture = load(currency_path)
			button.set_button_icon(currency_texture)

func _on_button_pressed():
	if button_pressed == false:
		var node = get_parent().get_parent().get_parent().get_parent()
		if node.name == "shop_menu" || node.name == "chest_menu": 
			button_pressed = true
			node.button_pressed(listing_info)

func sold():
	if listing_info[3] == "Smith":
		sold_icon.set_visible(true)
		button.set_visible(false)
	elif listing_info[3] == "Seer":
		pips_active += 1
		var pip_int = int(player_upgrades[listing_info[4]]["current_level"]) + 1
		StaticData.update_upgrade_level(listing_info[4], pip_int)
		for i in range(pips_active):
			pips[i].set_texture(pip_filled)
			pips[i].set_modulate(Color(1, 1, 1, 1))
		button.text = str(player_upgrades[listing_info[4]]["listing_cost"][str(pips_active + 1)])
		if pips_active == 5:
			button.set_visible(false)
		
