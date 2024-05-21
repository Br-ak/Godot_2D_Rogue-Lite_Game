extends CharacterBody2D

var speed = 200  # speed in pixels/sec
const type = "Player"

@onready var anim = $AnimatedSprite2D
@onready var weapon = $Weapon

@onready var gameNode = get_parent().get_parent()
@onready var hud = gameNode.get_node("CanvasLayer").get_node("Hud")
@onready var levelUpMenu = gameNode.get_node("CanvasLayer").get_node("Level Up Menu")
@onready var health_component = $HealthComponent
@onready var invincible_timer = $"HealthComponent/I-Frames"

var equipped_weapon
var test_weapon_equipped = false
var invincible_timer_length = 1

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

var player_health := 0:
	set(value):
		player_health = value
		hud.playerHealth = player_health

func _ready():
	anim.play("Side_Idle")

func _physics_process(_delta):
	if Engine.time_scale == 1:
		read_inputs()
	player_health = health_component.health

func read_inputs():
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var mousePosition = get_global_mouse_position()
	var angle = position.angle_to_point(mousePosition)
	
	if Input.is_action_pressed("attack_primary"):
		if equipped_weapon && equipped_weapon.has_method("attack"):
			equipped_weapon.attack()
	
	if Input.is_action_pressed("add_weapon_test") && test_weapon_equipped == false:
		test_weapon_equipped = true
		const ranged_weapon = preload("res://tscn/weapon.tscn")
		const melee_weapon = preload("res://tscn/melee_weapon.tscn")
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
		level_up()

func level_up():
	player_level += 1
	player_exp = 0
	gameNode.levelUpMenu()

func death():
	if gameNode.has_method("gameOverMenu"):
		gameNode.gameOverMenu()

func hurt():
	health_component.INVINCIBLE = true
	invincible_timer.start(invincible_timer_length)

func _on_i_frames_timeout():
	health_component.INVINCIBLE = false
