extends CharacterBody2D

var speed = 200  # speed in pixels/sec
const type = "Player"

@onready var anim = $AnimatedSprite2D
@onready var weapon = $Weapon

@onready var gameNode = get_parent().get_parent()
@onready var hud = gameNode.get_node("CanvasLayer").get_node("Hud")
var equipped_weapon

var player_exp := 0:
	set(value):
		player_exp = value
		hud.player_exp = player_exp

var player_level := 1:
	set(value):
		player_level = value
		hud.player_level = player_level

var killCounter := 0:
	set(value):
		killCounter = value
		hud.killCounter = killCounter

func _ready():
	anim.play("Side_Idle")

func _physics_process(_delta):
	if Engine.time_scale == 1:
		read_inputs()

func read_inputs():
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var mousePosition = get_global_mouse_position()
	var angle = position.angle_to_point(mousePosition)
	
	if Input.is_action_pressed("attack"):
		if equipped_weapon:
			equipped_weapon.attack()
	
	if Input.is_action_pressed("add_weapon_test") :
		const melee_weapon = preload("res://tscn/weapon.tscn")
		var new_melee_weapon = melee_weapon.instantiate()
		weapon.call("add_child", new_melee_weapon)
		equipped_weapon = $Weapon/Area2D
	
	if angle > -0.78 and angle < 0.78: #####looking right
		anim.scale.x = 1
		if direction: #player has movement
			anim.play("Side_Move")
		else: #No movement
			anim.play("Side_Idle")
	elif angle > 2.34 or angle < -2.34: #####looking left
		anim.scale.x = -1
		if direction: #player has movement
			anim.play("Side_Move")
		else: #No movement
			anim.play("Side_Idle")
	elif angle > 0.78 and angle < 2.34: #####looking up
		anim.scale.x = 1
		if direction: #player has movement
			anim.play("Down_Move")
		else: #No movement
			anim.play("Down_Idle")
	elif angle > -2.34 and angle < -0.78: #####looking down
		anim.scale.x = 1
		if direction: #player has movement
			anim.play("Up_Move")
		else: #No movement
			anim.play("Up_Idle")
	else:
		anim.play("Down_Idle")
	
	velocity = direction * speed
	move_and_slide()

func gain_exp(value):
	player_exp += value
	if player_exp >= 50:
		player_level += 1
		player_exp = 0

func death():
	if gameNode.has_method("gameOverMenu"):
		gameNode.gameOverMenu()
