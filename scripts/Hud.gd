extends Control
signal _fill_exp_bar
signal _reset_exp_bar

var XP_BAR_MAX = 100.00
var HP_BAR_MAX = 100

#
## Hud values
#

@onready var info = $AspectRatioContainer/CanvasLayer/info
@onready var weapon_swap = $"AspectRatioContainer/CanvasLayer/Weapon Swap"

# alert message
@onready var message_control = $"AspectRatioContainer/CanvasLayer/Message Control"
@onready var message = $"AspectRatioContainer/CanvasLayer/Message Control/Message"
@onready var message_animation_player = $"AspectRatioContainer/CanvasLayer/Message Control/Message/AnimationPlayer"

#Old EXP BAR
#@onready var exp_bar = $AspectRatioContainer/CanvasLayer/ColorRect/TextureRect
@onready var exp_bar = $"AspectRatioContainer/CanvasLayer/VBoxContainer2/XP Bar"

@onready var resource_bar = $"AspectRatioContainer/CanvasLayer/VBoxContainer/Resource Bar"

@onready var boss_health_bar_control = $"AspectRatioContainer/CanvasLayer/Boss Health Bar Control"
@onready var boss_name = $"AspectRatioContainer/CanvasLayer/Boss Health Bar Control/Boss Name"
@onready var boss_health = $"AspectRatioContainer/CanvasLayer/Boss Health Bar Control/Boss Health":
	set(value):
		if boss_health == null: # for some reason this is null upon startup for a second
			pass
		else:
			boss_health.value = value





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
	boss_health.set_max(200)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Engine.time_scale == 1:
		var fps = Engine.get_frames_per_second()
		info.text = "FPS: " + str(fps)

# static length currently
# displays animated message on ui
func alert_message(new_message):
	if !message.is_visible():
		message.set_visible(true)
	message.text = new_message
	message_animation_player.play("alert_fade_in")
	await message_animation_player.animation_finished
	message_animation_player.play("alert")
	message_animation_player.play("alert")
	message_animation_player.play("alert_fade_out")
	await message_animation_player.animation_finished
	message.set_visible(false)
	message_animation_player.stop()
