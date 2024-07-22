extends Node2D

@onready var scenery = $scenery

@onready var player = $Player

@onready var canvas_layer = $CanvasLayer
@onready var main_menu = $"CanvasLayer/Main Menu"
@onready var hud = $CanvasLayer/Hud
@onready var pause_menu = $CanvasLayer/PauseMenu
@onready var inventory_menu = $"CanvasLayer/Inventory Menu"
@onready var blacksmith = $Blacksmith
@onready var interact_icon_smith = $"Blacksmith/Interact Icon"
@onready var seer = $Seer
@onready var interact_icon_seer = $"Seer/Interact Icon"
@onready var audio_manager = self.get_tree().get_root().get_node("AudioManager")
@onready var dialog_box = $"CanvasLayer/Dialog Box"
@onready var interact_timer = $interact_timer
@onready var interact_icon_chest = $"Chest/Interact Icon"
@onready var chest_menu = $CanvasLayer/chest_menu
@onready var context_menu = $CanvasLayer/context_menu
@onready var smith_menu = $CanvasLayer/smith_menu

var can_interact = true
var sound_info = ["Npc Sounds"]
var smith_button_info = ["Talk", "Buy/Sell", "Exit"]
var seer_button_info = ["Talk", "Upgrades", "Exit"]
var interacting_with := ""
var interacted_with_already := []

# Called when the node enters the scene tree for the first time.
func _ready():
	player.init_for_hub()
	if hud:
		var hud_canvas = hud.get_node("AspectRatioContainer").get_node("CanvasLayer")
		for node in hud_canvas.get_children():
			node.set_visible(false)
			if node.name == "Weapon Swap" || node.name == "Message Control" || node.name == "currency":
				node.set_visible(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("player_interact"):
		if interact_icon_smith.player_interactable:
			smith_interactable_pressed()
		elif interact_icon_seer.player_interactable:
			seer_interactable_pressed()
		elif interact_icon_chest.player_interactable:
			chest_interactable_pressed()

func start_game():
	player.playable = true

func smith_interactable_pressed():
	if can_interact:
		interacting_with = "Smith"
		player.playable = false
		can_interact = false
		player.arrow_pointer.pointer_active = false
		#audio_manager.play_sound("interact", sound_info)
		interact_icon_smith.set_visible(false)
		
		dialog_box.speaker_name = "Smiffy"
		dialog_box.init_box()
		dialog_box.set_visible(true)
		if "Smith" not in interacted_with_already:
			dialog_box.fetch_text("Smiffy", "first_dialogue", "1")
			interacted_with_already.append("Smith")
		else:
			var rng = randi_range(1, 3)
			dialog_box.fetch_text("Smiffy", "intro", str(rng))
		context_menu.init()
		context_menu.set_visible(true)
		context_menu.button1_text = smith_button_info[0]
		context_menu.button2_text = smith_button_info[1]
		context_menu.button3_text = smith_button_info[2]

func seer_interactable_pressed():
	if can_interact:
		interacting_with = "Seer"
		player.playable = false
		can_interact = false
		player.arrow_pointer.pointer_active = false
		#audio_manager.play_sound("interact", sound_info)
		interact_icon_seer.set_visible(false)
		
		context_menu.init()
		context_menu.set_visible(true)
		context_menu.button1_text = seer_button_info[0]
		context_menu.button2_text = seer_button_info[1]
		context_menu.button3_text = seer_button_info[2]
		dialog_box.speaker_name = "Seer"
		dialog_box.init_box()
		dialog_box.set_visible(true)
		if "Seer" not in interacted_with_already:
			dialog_box.fetch_text("Seer", "first_dialogue", "1")
			interacted_with_already.append("Seer")
		else:
			var rng = randi_range(1, 3)
			dialog_box.fetch_text("Seer", "intro", str(rng))

func chest_interactable_pressed():
	if can_interact:
		player.playable = false
		can_interact = false
		interact_icon_chest.set_visible(false)
		chest_menu.init_listings()
		chest_menu.set_visible(true)

func _on_interact_timer_timeout():
	can_interact = true

func context_talk_button():
	if interacting_with == "Seer" && dialog_box.button_pressable:
		dialog_box.fetch_text("Seer", "hub_text", "2")
	elif interacting_with == "Smith" && dialog_box.button_pressable:
		dialog_box.fetch_text("Smiffy", "hub_text", "2")

func context_merchant_button():
	if interacting_with == "Seer":
		pass
	elif interacting_with == "Smith":
		context_exit_button()
		smith_menu.set_visible(true)

# exit button just closes other ui elements
func context_exit_button():
	dialog_box.menu_closed = true
	for node in canvas_layer.get_children():
		if node.name == "Hud":
			node.set_visible(true)
		else:
			node.set_visible(false)
	player.playable = true
	interacting_with = ""
	can_interact = true
