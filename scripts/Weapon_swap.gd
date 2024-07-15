extends Control

@onready var weapon_swap = $"."
@onready var holstered_item = $"Holstered Item"
@onready var equipped_item = $"Equipped Item"
@onready var swap_icon = $"Swap Icon"
var game
var world
var player


@onready var weapon_data = StaticData.weapons["weapons"]

#load(texture_path)
# Called when the node enters the scene tree for the first time.
func _ready():
	init()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func init():
	
	for node in self.get_tree().get_root().get_children():
		if node.name == "Hub World": world = node
		elif node.name == "Game": 
			game = node
			world = game.get_node("World")
	player = world.get_node("Player")
	var weapon_info
	if player.equipped_weapon:
		weapon_info = weapon_data[player.equipped_weapon.WEAPON_NAME]
		var texture_path = weapon_info["asset_path"]
		var icon_texture = load(texture_path)
		equipped_item.set_texture(icon_texture)
		equipped_item.set_visible(true)
	if player.holstered_weapon:
		weapon_info = weapon_data[player.holstered_weapon.WEAPON_NAME]
		var texture_path = weapon_info["asset_path"]
		var icon_texture = load(texture_path)
		holstered_item.set_texture(icon_texture)
		swap_icon.set_visible(true)
		holstered_item.set_visible(true)

