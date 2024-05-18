extends Control
signal _fill_exp_bar
signal _reset_exp_bar

var XP_BAR_MAX = 50.00
var HP_BAR_MAX = 100

#
## Hud values
#

@onready var info = $AspectRatioContainer/CanvasLayer/info

#Old EXP BAR
#@onready var exp_bar = $AspectRatioContainer/CanvasLayer/ColorRect/TextureRect
@onready var exp_bar = $"AspectRatioContainer/CanvasLayer/XP Bar"
@onready var resource_bar = $"AspectRatioContainer/CanvasLayer/VBoxContainer/Resource Bar"

@onready var playerHealth = $"AspectRatioContainer/CanvasLayer/VBoxContainer/Health Bar":
	set(value):
		if playerHealth == null: # for some reason this is null upon startup for a second
			pass
		else:
			playerHealth.value = value

@onready var killCounter = $AspectRatioContainer/CanvasLayer/kills:
	set(value):
		if killCounter == null: # for some reason this is null upon startup for a second
			pass
		else:
			killCounter.text = "Kills: " + str(value)

@onready var player_level = $AspectRatioContainer/CanvasLayer/level:
	set(value):
		if player_level == null: # for some reason this is null upon startup for a second
			pass
		else:
			player_level.text = "Level: " + str(value)
			exp_bar.value = 0

@onready var player_exp = $AspectRatioContainer/CanvasLayer/exp:
	set(value):
		if player_exp == null: # for some reason this is null upon startup for a second
			pass
		else:
			player_exp.text = "Exp: " + str(value)
			exp_bar.value = value

@onready var gameTimer = $AspectRatioContainer/CanvasLayer/timer:
	set(value):
		if gameTimer == null: # for some reason this is null upon startup for a second
			pass
		else:
			gameTimer.text = "Time: " + str(value)

#
## Functions
#

# Called when the node enters the scene tree for the first time.
func _ready():
	exp_bar.set_max(XP_BAR_MAX)
	playerHealth.set_max(HP_BAR_MAX)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Engine.time_scale == 1:
		var fps = Engine.get_frames_per_second()
		info.text = "FPS: " + str(fps)

#old xp bar functions
#func on_fill_exp_bar(value):
#	if value != 0:
#		var percentage_to_fill = float(value / XP_BAR_MAX)
#		exp_bar.texture.set_fill_from(Vector2 (percentage_to_fill, 0))
#		exp_bar.texture.set_fill_to(Vector2 (percentage_to_fill + 0.1, 0))
#
#func on_reset_exp_bar():
#	exp_bar.texture.set_fill_from(Vector2 (0, 0))
#	exp_bar.texture.set_fill_to(Vector2 (0.1, 0))
