extends Control

@onready var menu_listing = $"."
@onready var texture_rect_2 = $TextureRect2
@onready var texture_rect = $TextureRect
@onready var button = $TextureRect/Button
@onready var label = $TextureRect/Label
@onready var desc = $TextureRect/desc
@onready var texture_rect_3 = $TextureRect/TextureRect3
@onready var sold_icon = $TextureRect3

var icon_path
var button_pressed := false 
var listing_info = [] # name, cost, description, seller
var currency_path
var currency_texture


func init_listing():
	if icon_path:
		var texture = load(icon_path)
		texture_rect.set_texture(texture)
	if listing_info:
		label.text = listing_info[0]
		button.text = listing_info[1]
		if listing_info[3] == "Smith": currency_path = "res://assets/visual/upgrades/currency_coin.png"
		elif listing_info[3] == "Seer": currency_path = "res://assets/visual/upgrades/currency_mana.png"
		if currency_path:
			currency_texture = load(currency_path)
			button.set_button_icon(currency_texture)


func _on_button_pressed():
	
	if button_pressed == false:
		var node = get_parent().get_parent().get_parent().get_parent()
		if node.name == "smith_menu" || node.name == "seer_menu" || node.name == "chest_menu": 
			button_pressed = true
			
			node.button_pressed(listing_info)

func sold():
	sold_icon.set_visible(true)
	button.set_visible(false)
