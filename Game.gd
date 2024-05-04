extends Node2D

@onready var pause_menu = $CanvasLayer/PauseMenu
@onready var game_over_menu = $"CanvasLayer/Game Over Menu"
@onready var timer = $Timer
@onready var hud = $CanvasLayer/Hud
var paused = false

var runTimer := 0:
	set(value):
		runTimer = value
		hud.runTimer = runTimer
		

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start(1) 
	if Engine.time_scale != 1:
		Engine.time_scale = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("pause_game"):
		pauseMenu()

func pauseMenu():
	if pause_menu.is_visible():
		pause_menu.set_visible(false)
		Engine.time_scale = 1
	else:
		pause_menu.set_visible(true)
		Engine.time_scale = 0
		
	paused = !paused

func gameOverMenu():
	game_over_menu.set_visible(true)
	Engine.time_scale = 0


func _on_timer_timeout():
	runTimer += 1
	timer.start(1) 
