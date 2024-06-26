extends CharacterBody2D
signal update_weapon_stats_signal(new_damage)

var speed = 200  # speed in pixels/sec
const type = "Player"
const ranged_weapon = preload("res://tscn/weapon.tscn")
const melee_weapon = preload("res://tscn/melee_weapon.tscn")
var new_melee_weapon
var new_holstered_weapon

@onready var anim = $AnimatedSprite2D
@onready var weapon = $Weapon

@onready var gameNode = get_parent().get_parent()
@onready var hud = gameNode.get_node("CanvasLayer").get_node("Hud")
@onready var levelUpMenu = gameNode.get_node("CanvasLayer").get_node("Level Up Menu")
@onready var health_component = $HealthComponent
@onready var invincible_timer = $"HealthComponent/I-Frames"
@onready var inventory_menu = gameNode.get_node("CanvasLayer").get_node("Inventory Menu")
@onready var swap_timer = $"Weapon/Swap Timer"

@onready var visible_range_area = $visible_range_area
@onready var visible_range_shape = $visible_range_area/visible_range_shape

@onready var audio_manager = self.get_tree().get_root().get_node("AudioManager")

var sound_info = ["Player Sounds"]
var equipped_weapon
var holstered_weapon
var test_weapon_equipped = false
var weapon_swappable = false
var invincible_timer_length = 1
var level_ups = 0

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
	var new_range = RectangleShape2D.new()
	new_range.size.x = get_viewport().size.x + (get_viewport().size.x * 0.10)
	new_range.size.y = get_viewport().size.y + (get_viewport().size.y * 0.10)
	visible_range_shape.shape = new_range
	anim.play("Side_Idle")

func _physics_process(_delta):
	if Engine.time_scale == 1:
		read_inputs()
	player_health = health_component.health

func read_inputs():
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var mousePosition = get_global_mouse_position()
	var angle = position.angle_to_point(mousePosition)
	
	if direction && !audio_manager.sound_is_playing("move", sound_info) && Engine.time_scale == 1:
		audio_manager.play_sound("move", sound_info)
	elif !direction || Engine.time_scale != 1:
		audio_manager.stop_sound("move", sound_info)
	
	
	if Input.is_action_pressed("attack_primary"):
		if equipped_weapon && equipped_weapon.has_method("attack") && equipped_weapon.can_attack:
			equipped_weapon.attack()
			
	if Input.is_action_just_pressed("attack_secondary"):
		if equipped_weapon && equipped_weapon.has_method("attack_secondary") && equipped_weapon.can_attack:
			equipped_weapon.attack_secondary()
	
	if test_weapon_equipped == false:
		test_weapon_equipped = true
		new_melee_weapon = melee_weapon.instantiate()
		new_holstered_weapon = ranged_weapon.instantiate()
		weapon.call("add_child", new_melee_weapon)
		equipped_weapon = new_melee_weapon
		holstered_weapon = new_holstered_weapon
		inventory_menu.init_weapon_panels()
		hud.weapon_swap.init()
		weapon_swappable = true
	
	if Input.is_action_pressed("weapon_swap") && weapon_swappable:
		audio_manager.play_sound("hurt", sound_info)
		weapon_swappable = false
		var new_weapon
		if equipped_weapon.WEAPON_NAME == "gun":
			new_weapon = melee_weapon
		elif equipped_weapon.WEAPON_NAME == "staff":
			new_weapon = ranged_weapon
		
		var temp_weapon = equipped_weapon
		var new_equipped_weapon = new_weapon.instantiate()
		weapon.call("add_child", new_equipped_weapon)
		equipped_weapon.queue_free()
		equipped_weapon = new_equipped_weapon
		holstered_weapon = temp_weapon
		inventory_menu.swap_weapons()
		hud.weapon_swap.init()
		swap_timer.start(1)
	
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
	if player_exp >= 100:
		level_up()

func level_up():
	player_level += 1
	player_exp = 0
	level_ups += 1
	if Engine.time_scale == 1:
		gameNode.levelUpMenu()

func death():
	if gameNode.has_method("gameOverMenu"):
		gameNode.gameOverMenu()

func hurt():
	audio_manager.play_sound("hurt", sound_info)
	health_component.INVINCIBLE = true
	invincible_timer.start(invincible_timer_length)

func _on_i_frames_timeout():
	health_component.INVINCIBLE = false

func _on_swap_timer_timeout():
	weapon_swappable = true

func _on_visible_range_area_body_entered(body):
	if body is CharacterBody2D:
		if body.type == "Enemy":
			if !body.is_visible():
				body.set_visible(true)
			if body.collision && body.collision.is_disabled():
				body.collision.set_disabled(false)
