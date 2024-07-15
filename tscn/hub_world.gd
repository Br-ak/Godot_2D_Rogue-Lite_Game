extends Node2D

@onready var scenery = $scenery

@onready var player = $Player

@onready var canvas_layer = $CanvasLayer
@onready var main_menu = $"CanvasLayer/Main Menu"
#@onready var hud = $CanvasLayer/Hud
@onready var pause_menu = $CanvasLayer/PauseMenu
@onready var inventory_menu = $"CanvasLayer/Inventory Menu"
@onready var blacksmith = $Blacksmith
@onready var interact_icon_smith = $"Blacksmith/Interact Icon"
@onready var seer = $Seer
@onready var interact_icon_seer = $"Seer/Interact Icon"
@onready var audio_manager = self.get_tree().get_root().get_node("AudioManager")
@onready var dialog_box = $"CanvasLayer/Dialog Box"
@onready var interact_timer = $interact_timer

var can_interact = true
var sound_info = ["Npc Sounds"]

# Called when the node enters the scene tree for the first time.
func _ready():
	player.init_for_hub()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("player_interact"):
		if interact_icon_smith.player_interactable:
			smith_interactable_pressed()
		elif interact_icon_seer.player_interactable:
			seer_interactable_pressed()

func start_game():
	player.playable = true
	

func smith_interactable_pressed():
	if can_interact:
		player.playable = false
		can_interact = false
		player.arrow_pointer.pointer_active = false
		#audio_manager.play_sound("interact", sound_info)
		interact_icon_smith.set_visible(false)
		dialog_box.speaker_name = "Smiffy"
		dialog_box.speaker_icon_path = "res://assets/npc/smiffy_portrait.png"
		dialog_box.init_box()
		dialog_box.set_visible(true)
		dialog_box.fetch_text("Seer", "hub_text", "1")

func seer_interactable_pressed():
	if can_interact:
		player.playable = false
		can_interact = false
		player.arrow_pointer.pointer_active = false
		#audio_manager.play_sound("interact", sound_info)
		interact_icon_smith.set_visible(false)
		dialog_box.speaker_name = "Seer"
		dialog_box.speaker_icon_path = "res://assets/npc/seer_portrait.png"
		dialog_box.init_box()
		dialog_box.set_visible(true)
		dialog_box.fetch_text("Seer", "hub_text", "1")

func _on_interact_timer_timeout():
	can_interact = true
