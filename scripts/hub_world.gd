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
@onready var shop_menu = $CanvasLayer/shop_menu
@onready var interact_icon_satyr = $"Satyr Steve/Interact Icon"
@onready var timer = $Doorway_detection/Timer
@onready var fade_box = $CanvasLayer/fade_box
@onready var fade_timer = $CanvasLayer/fade_box/fade_timer
@onready var tutorial = $CanvasLayer/Tutorial
@onready var parallax_background = $CanvasLayer/ParallaxBackground

var interacting_with := ""
var interacted_with_already := []
var can_interact = true
var sound_info = ["Npc Sounds"]

var smith_button_info = ["Talk", "Buy/Sell", "Exit"]
var smith_shop_info = ["Smiffy's Shop", "weapons", "Smith"]

var seer_button_info = ["Talk", "Upgrades", "Exit"]
var seer_shop_info = ["Enhancements", "player upgrades", "Seer"]

var satyr_button_info = ["Yes (Display Tutorial)", "No (Skip Tutorial)"]

var exit_button_info = ["Yes", "No"]
var fade_start
var fade_count := 0
var weapon_equipped := false
var failed_exit = false
var busy := false
# Called when the node enters the scene tree for the first time.
func _ready():
	player.init_for_hub()
	if hud:
		var hud_canvas = hud.get_node("AspectRatioContainer").get_node("CanvasLayer")
		for node in hud_canvas.get_children():
			node.set_visible(false)
			if node.name == "Weapon Swap" || node.name == "Message Control" || node.name == "currency" || node.name == "ParallaxBackground":
				node.set_visible(true)
			else: node.set_visible(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("player_interact") && !busy:
		busy = true
		if interact_icon_smith.player_interactable:
			smith_interactable_pressed()
		elif interact_icon_seer.player_interactable:
			seer_interactable_pressed()
		elif interact_icon_chest.player_interactable:
			chest_interactable_pressed()
		elif interact_icon_satyr.player_interactable:
			satyr_interactable_pressed()
	if Input.is_action_just_pressed("pause_game") && Engine.time_scale == 1 || Input.is_action_just_pressed("pause_game") && pause_menu.is_visible() && !busy: 
		busy = true
		pauseMenu()

func pauseMenu():
	main_menu.set_visible(false)
	if pause_menu.is_visible():
		pause_menu.set_visible(false)
		player.playable = true
		busy = false
	else:
		pause_menu.set_visible(true)
		player.playable = false


func start_game():
	player.playable = true

func smith_interactable_pressed():
	if can_interact && player.playable:
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
		context_menu.set_visible(true)
		context_menu.button1_text = smith_button_info[0]
		context_menu.button2_text = smith_button_info[1]
		context_menu.button3_text = smith_button_info[2]
		context_menu.init()

func seer_interactable_pressed():
	if can_interact && player.playable:
		interacting_with = "Seer"
		player.playable = false
		can_interact = false
		player.arrow_pointer.pointer_active = false
		#audio_manager.play_sound("interact", sound_info)
		interact_icon_seer.set_visible(false)
		
		context_menu.set_visible(true)
		context_menu.button1_text = seer_button_info[0]
		context_menu.button2_text = seer_button_info[1]
		context_menu.button3_text = seer_button_info[2]
		context_menu.init()
		dialog_box.speaker_name = "Seer"
		dialog_box.init_box()
		dialog_box.set_visible(true)
		if "Seer" not in interacted_with_already:
			dialog_box.fetch_text("Seer", "first_dialogue", "1")
			interacted_with_already.append("Seer")
		else:
			var rng = randi_range(1, 3)
			dialog_box.fetch_text("Seer", "intro", str(rng))

func satyr_interactable_pressed():
	if can_interact && player.playable:
		interacting_with = "Satyr Steve"
		player.playable = false
		can_interact = false
		player.arrow_pointer.pointer_active = false
		#audio_manager.play_sound("interact", sound_info)
		interact_icon_seer.set_visible(false)
		
		context_menu.set_visible(true)
		context_menu.button1_text = satyr_button_info[0]
		context_menu.button3_text = satyr_button_info[1]
		context_menu.init()
		context_menu.button_2.set_visible(false)
		dialog_box.speaker_name = "Satyr Steve"
		dialog_box.init_box()
		dialog_box.set_visible(true)
		if "Satyr Steve" not in interacted_with_already:
			dialog_box.fetch_text("Satyr Steve", "first_dialogue", "1")
			interacted_with_already.append("Satyr Steve")
		else:
			var rng = randi_range(1, 3)
			dialog_box.fetch_text("Satyr Steve", "intro", str(rng))
			
func chest_interactable_pressed():
	if can_interact && player.playable:
		player.playable = false
		can_interact = false
		interact_icon_chest.set_visible(false)
		chest_menu.init_listings()
		chest_menu.set_visible(true)

func _on_interact_timer_timeout():
	can_interact = true

func context_talk_button():
	var rng = randi_range(1, 3)
	if interacting_with == "Seer" && dialog_box.button_pressable:
		dialog_box.fetch_text("Seer", "intro", str(rng))
	elif interacting_with == "Smith" && dialog_box.button_pressable:
		dialog_box.fetch_text("Smiffy", "intro", str(rng))
	elif interacting_with == "Satyr Steve" && dialog_box.button_pressable:
		#commence tutoral
		print("wahe")
		tutorial.init()
	elif interacting_with == "exit door"  && dialog_box.button_pressable:
		if !weapon_equipped:
			context_menu.set_visible(true)
			context_menu.button3_text = "Close"
			context_menu.init()
			context_menu.button_2.set_visible(false)
			context_menu.button_1.set_visible(false)
			dialog_box.speaker_name = "Satyr Steve"
			dialog_box.init_box()
			dialog_box.set_visible(true)
			dialog_box.fetch_text("Satyr Steve", "tutorial_text", "exit_without_weapon")
			interacting_with = "exit door"
			failed_exit = true
			context_exit_button()
		else:
			player.anim.play("Side_Idle")
			fade_start = true
			fade_timer.start(0.1)

func context_merchant_button():
	if interacting_with == "Seer":
		context_exit_button()
		shop_menu.menu_info = seer_shop_info
		shop_menu.init_listings()
		shop_menu.set_visible(true)
	elif interacting_with == "Smith":
		context_exit_button()
		shop_menu.menu_info = smith_shop_info
		shop_menu.init_listings()
		shop_menu.set_visible(true)

# exit button just closes other ui elements
func context_exit_button():
	if interacting_with == "exit door":
		player.playable = true
		Input.action_press("ui_down")
		timer.start(0.3)
	else:
		dialog_box.menu_closed = true
		for node in canvas_layer.get_children():
			if node.name == "Hud" || node.name == "ParallaxBackground":
				node.set_visible(true)
			else:
				node.set_visible(false)
		player.playable = true
		interacting_with = ""
		can_interact = true
	busy = false


func _on_doorway_detection_area_entered(area):
	if area is HitboxComponent:
		if area.get_parent().type == "Player":
			interacting_with = "exit door"
			player.playable = false
			context_menu.set_visible(true)
			context_menu.button1_text = exit_button_info[0]
			context_menu.button3_text = exit_button_info[1]
			context_menu.init()
			context_menu.label.text = "Ready for a fight?"
			context_menu.label.set_visible(true)
			context_menu.button_2.set_visible(false)

#doorway failed exit timer
func _on_timer_timeout():
	timer.stop()
	#dialog_box.menu_closed = true
	for node in canvas_layer.get_children():
		if node.name == "Hud" || node.name == "ParallaxBackground":
			node.set_visible(true)
		else:
			node.set_visible(false)
	if failed_exit:
		dialog_box.set_visible(true)
		context_menu.set_visible(true)
		failed_exit = false
	Input.action_release("ui_down")
	#player.playable = true
	interacting_with = ""
	can_interact = true
	#dialog_box.set_visible(false)


func _on_fade_timer_timeout():
	if fade_count > 20:
		fade_timer.stop()
		get_tree().change_scene_to_file("res://tscn/game.tscn")
	else:
		fade_count += 1
		if fade_start:
			player.playable = false
			fade_start = false
			for node in canvas_layer.get_children():
				if node.name == "fade_box":
					node.set_visible(true)
				else:
					node.set_visible(false)
			fade_box.set_self_modulate(fade_box.get_self_modulate() + Color(1, 1, 1, 0.05))
			fade_timer.start(0.1)
		else:
			fade_box.set_self_modulate(fade_box.get_self_modulate() + Color(1, 1, 1, 0.05))
			fade_timer.start(0.1)
