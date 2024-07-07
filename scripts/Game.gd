extends Node2D

@onready var pause_menu = $CanvasLayer/PauseMenu
@onready var game_over_menu = $"CanvasLayer/Game Over Menu"
@onready var level_up_menu = $"CanvasLayer/Level Up Menu"
@onready var inventory_menu = $"CanvasLayer/Inventory Menu"
@onready var audio_manager = self.get_tree().get_root().get_node("AudioManager")
@onready var timer = $Timer
@onready var hud = $CanvasLayer/Hud
@onready var world = $World

var music_data = ["Music"]

var gameTimer := 0:
	set(value):
		gameTimer = value
		hud.gameTimer = gameTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	SharedFunctions.init_variables()
	audio_manager.play_music("BGM_battle", music_data)
	timer.start(1) 
	if Engine.time_scale != 1:
		Engine.time_scale = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("pause_game") && Engine.time_scale == 1 || Input.is_action_just_pressed("pause_game") && pause_menu.is_visible(): 
		pauseMenu()
	if Input.is_action_just_pressed("debug_level_up") && Engine.time_scale == 1 || Input.is_action_just_pressed("debug_level_up") && level_up_menu.is_visible():
		levelUpMenu()
	if Input.is_action_just_pressed("debug_inventory") && Engine.time_scale == 1 || Input.is_action_just_pressed("debug_inventory") && inventory_menu.is_visible():
		inventoryMenu()

func pauseMenu():
	if pause_menu.is_visible():
		pause_menu.set_visible(false)
		Engine.time_scale = 1
	else:
		pause_menu.set_visible(true)
		Engine.time_scale = 0

func levelUpMenu():
	if level_up_menu.is_visible():
		level_up_menu._on_exit_pressed()
		Engine.time_scale = 1
	else:
		level_up_menu.on_open()
		level_up_menu.set_visible(true)
		Engine.time_scale = 0

func inventoryMenu():
	if inventory_menu.is_visible():
		inventory_menu.set_visible(false)
		Engine.time_scale = 1
	else:
		inventory_menu.set_visible(true)
		Engine.time_scale = 0

func gameOverMenu():
	Engine.time_scale = 0
	game_over_menu.set_visible(true)

func _on_timer_timeout():
	gameTimer += 1
	timer.start(1) 


