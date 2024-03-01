extends CharacterBody2D

var speed = 200  # speed in pixels/sec
var frameCount = 0
@onready var player_sprite = $Player_Sprite

var melee_timer : Timer
var allow_melee = true
var attack_type = 1

func _ready():
	melee_timer = $Melee_Timer
	player_sprite.play("Idle")

func _physics_process(_delta):
	read_inputs()

func read_inputs():
	var attack = Input.is_action_pressed("player_attack")
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
#	if attack:
#		melee(attack)
	
	movement(direction)
	move_and_slide()

func movement(direction):
	velocity = direction * speed
 
	if get_global_mouse_position().x > position.x:
		player_sprite.scale.x = 1
	elif get_global_mouse_position().x < position.x:
		player_sprite.scale.x = -1
	if direction:
		player_sprite.play("Run")
	else:
		player_sprite.play("Idle")

#func melee(attack):
#
#
#	if attack == true && allow_melee == true:
#		allow_melee = false
#		melee_timer.start(1)
#		if attack_type == 1:
#			player_sprite.play("Attack_1")
#			attack_type = 2
#		elif attack_type == 2:
#			player_sprite.play("Attack_2")
#			attack_type = 1
#		await player_sprite.animation_finished

func _on_melee_timer_timeout():
	allow_melee = true
