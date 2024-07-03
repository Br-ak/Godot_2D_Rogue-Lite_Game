extends CharacterBody2D
signal update_weapon_stats_signal(new_damage)

var speed = 150  # speed in pixels/sec
const type = "Player"
const ranged_weapon = preload("res://tscn/weapon.tscn")
const melee_weapon = preload("res://tscn/melee_weapon.tscn")
const magic_component_weapon = preload("res://tscn/magic_components_weapon.tscn")
var new_active_weapon
var new_holstered_weapon

@onready var anim = $AnimatedSprite2D
@onready var weapon = $Weapon
@onready var sound_timer = $"Sound Timer"

@onready var gameNode = get_parent().get_parent()
@onready var hud = gameNode.get_node("CanvasLayer").get_node("Hud")
@onready var levelUpMenu = gameNode.get_node("CanvasLayer").get_node("Level Up Menu")
@onready var health_component = $HealthComponent
@onready var invincible_timer = $"HealthComponent/I-Frames"
@onready var inventory_menu = gameNode.get_node("CanvasLayer").get_node("Inventory Menu")
@onready var swap_timer = $"Weapon/Swap Timer"

@onready var audio_manager = self.get_tree().get_root().get_node("AudioManager")
@onready var navigation_region_2d = $NavigationRegion2D
@onready var timer = $NavigationRegion2D/Timer

var sound_info = ["Player Sounds"]
var equipped_weapon
var holstered_weapon
var test_weapon_equipped = false
var weapon_swappable = false
var invincible_timer_length = 1
var level_ups = 0
var direction_facing = ""
var sound_rng
var sound_string = "move1"
var sound_playable = true

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
	#print(direction)
	var mousePosition = get_global_mouse_position()
	var angle = position.angle_to_point(mousePosition)
	
	if direction && !audio_manager.sound_is_playing(sound_string, sound_info) && Engine.time_scale == 1 && sound_playable:
		sound_rng = randi_range(1, 3)
		sound_string = "move" + str(sound_rng)
		audio_manager.play_sound(sound_string, sound_info)
		sound_playable = false
		sound_timer.start(0.3)
	elif !direction || Engine.time_scale != 1:
		audio_manager.stop_sound(sound_string, sound_info)
	
	
	if Input.is_action_pressed("attack_primary"):
		if equipped_weapon && equipped_weapon.has_method("attack") && equipped_weapon.can_attack:
			equipped_weapon.attack()
			
	if Input.is_action_just_pressed("attack_secondary"):
		if equipped_weapon && equipped_weapon.has_method("attack_secondary") && equipped_weapon.can_attack:
			equipped_weapon.attack_secondary()
	
	if test_weapon_equipped == false:
		test_weapon_equipped = true
		new_active_weapon = magic_component_weapon.instantiate()
		new_holstered_weapon = ranged_weapon.instantiate()
		weapon.call("add_child", new_active_weapon)
		equipped_weapon = new_active_weapon
		holstered_weapon = new_holstered_weapon
		inventory_menu.init_weapon_panels()
		hud.weapon_swap.init()
		weapon_swappable = true
	
	if Input.is_action_pressed("weapon_swap") && weapon_swappable:
		audio_manager.play_sound("hurt", sound_info)
		weapon_swappable = false
		var new_weapon
		if equipped_weapon.WEAPON_NAME == "magic components":
			new_weapon = melee_weapon
		elif equipped_weapon.WEAPON_NAME == "staff":
			new_weapon = magic_component_weapon
		
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
		direction_facing = "right"
		anim.scale.x = 1
		if direction: #player has movement
			anim.play("Side_Move")
		else: #No movement
			anim.play("Side_Idle")
	elif angle > 2.34 or angle < -2.34: #####looking left
		direction_facing = "left"
		anim.scale.x = -1
		if direction: #player has movement
			anim.play("Side_Move")
		else: #No movement
			anim.play("Side_Idle")
	elif angle > 0.78 and angle < 2.34: #####looking up
		direction_facing = "up"
		anim.scale.x = 1
		if direction: #player has movement
			anim.play("Down_Move")
		else: #No movement
			anim.play("Down_Idle")
	elif angle > -2.34 and angle < -0.78: #####looking down
		direction_facing = "down"
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

func _on_sound_timer_timeout():
	sound_playable = true


func _on_timer_timeout():
	pass
