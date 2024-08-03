extends CharacterBody2D
signal update_weapon_stats_signal(new_damage)

var starting_speed = 200  # speed in pixels/sec
var speed

const type = "Player"
const staff_weapon = preload("res://tscn/melee_weapon.tscn")
const magic_component_weapon = preload("res://tscn/magic_components_weapon.tscn")
const spell_book_weapon = preload("res://tscn/spell_book.tscn")
const gun_weapon = preload("res://tscn/weapon.tscn")

var new_active_weapon
var new_holstered_weapon

@onready var anim = $AnimatedSprite2D
@onready var weapon = $Weapon
@onready var sound_timer = $"Sound Timer"
@onready var arrow_pointer = $arrow_pointer

@onready var gameNode
@onready var hud
@onready var levelUpMenu 
@onready var health_component = $HealthComponent
@onready var invincible_timer = $"HealthComponent/I-Frames"
@onready var inventory_menu
@onready var swap_timer = $"Weapon/Swap Timer"
@onready var scenery

@onready var audio_manager = self.get_tree().get_root().get_node("AudioManager")
@onready var navigation_region_2d = $NavigationRegion2D
@onready var timer = $NavigationRegion2D/Timer
@onready var debug_timer = $"DEBUG TIMER"

@onready var game
@onready var world
@onready var mobs
@onready var player_upgrades = StaticData.player_upgrades["upgrades"]
@onready var weapon_data = StaticData.weapons["weapons"]

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
var player_levelup_xp := 100
var equipped_weapon_upgrades = []
var holstered_weapon_upgrades = []

var debug_avail = true
var location := "game"
var playable = true
var weapons_purchased = []
var skills_purchased = []

var perma_upgrade_health := 0
var perma_upgrade_speed := 0
var perma_upgrade_damage := 0
var perma_upgrade_attack_speed := 0
var perma_upgrade_follower_damage := 0
var perma_upgrade_follower_attack_speed := 0
var health_total

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

var player_health := 100:
	set(value):
		player_health = value
		if hud:
			hud.HP_BAR_MAX = health_total
			hud.playerHealth = player_health

var player_coins := 0:
	set(value):
		player_coins = value
		if hud:
			hud.player_coins = player_coins

var player_crystal := 0:
	set(value):
		player_crystal = value
		if hud:
			hud.player_crystal = player_crystal

func _ready():
	anim.play("Side_Idle")
	init_stats()

func init_stats():
	for upgrade in player_upgrades:
		var upgrade_level = player_upgrades[upgrade]["current_level"]
		if upgrade_level != 0:
			var upgrade_value = player_upgrades[upgrade]["level"][str(upgrade_level)]
			if upgrade == "attack_speed_up": perma_upgrade_attack_speed = upgrade_value
			elif upgrade == "damage_up": perma_upgrade_damage = upgrade_value
			elif upgrade == "hp_up": perma_upgrade_health = upgrade_value
			elif upgrade == "speed_up": perma_upgrade_speed = upgrade_value
			elif upgrade == "follower_damage": perma_upgrade_follower_damage = upgrade_value
			elif upgrade == "follower_attack_speed": perma_upgrade_follower_attack_speed = upgrade_value
	
	if perma_upgrade_health:
		player_health += perma_upgrade_health
		health_component.MAX_HEALTH = player_health
		health_component.health = player_health
	health_total = player_health
	
	speed = starting_speed + perma_upgrade_speed
	
	if equipped_weapon:
		var attack_count = 0
		for attacks in weapon_data[equipped_weapon.WEAPON_NAME]:
			attack_count += 1
		if attack_count > 0 && equipped_weapon.primary_attack is Attack: 
			equipped_weapon.primary_attack.attack_damage_increase += perma_upgrade_damage
			var temp = perma_upgrade_attack_speed / 100
			equipped_weapon.primary_attack.attack_reset_time_multiplier -= temp
		if attack_count > 1 && equipped_weapon.secondary_attack is Attack:
			equipped_weapon.secondary_attack.attack_damage_increase += perma_upgrade_damage
			var temp = perma_upgrade_attack_speed / 100
			equipped_weapon.secondary_attack.attack_reset_time_multiplier -= temp
	
	if get_parent().has_node("Follower"):
		var follower = get_parent().get_node("Follower")
		follower.perma_upgrade_attack_speed = perma_upgrade_follower_attack_speed
		follower.perma_upgrade_attack_damage = perma_upgrade_follower_damage



func init_for_hub():
	StaticData.player_info.location = "hub"
	
	location = "hub"
	playable = false
	anim = $AnimatedSprite2D
	weapon = $Weapon
	weapon.set_visible(false)
	sound_timer = $"Sound Timer"
	gameNode = get_parent()
	hud = gameNode.get_node("CanvasLayer").get_node("Hud")
	inventory_menu = gameNode.get_node("CanvasLayer").get_node("Inventory Menu")
	swap_timer = $"Weapon/Swap Timer"
	audio_manager = self.get_tree().get_root().get_node("AudioManager")
	navigation_region_2d = $NavigationRegion2D
	world = self
	
	player_crystal = StaticData.player_info.currency.crystal
	player_coins = StaticData.player_info.currency.coin

func loaded_data():
	if StaticData.player_info.equipped_weapon != null:
		weapon_add(StaticData.player_info.equipped_weapon, 1)
	if StaticData.player_info.holstered_weapon != null:
		weapon_add(StaticData.player_info.holstered_weapon, 2)
	
	player_crystal = StaticData.player_info.currency.crystal
	player_coins = StaticData.player_info.currency.coin

func init_for_game():
	StaticData.player_info.location = "game"
	if StaticData.player_info.equipped_weapon != null:
		weapon_add(StaticData.player_info.equipped_weapon, 1)
	if StaticData.player_info.holstered_weapon != null:
		weapon_add(StaticData.player_info.holstered_weapon, 2)
		
	
	
	anim = $AnimatedSprite2D
	weapon = $Weapon
	sound_timer = $"Sound Timer"
	arrow_pointer = $arrow_pointer
	gameNode = get_parent().get_parent()
	hud = gameNode.get_node("CanvasLayer").get_node("Hud")
	levelUpMenu = gameNode.get_node("CanvasLayer").get_node("Level Up Menu")
	health_component = $HealthComponent
	invincible_timer = $"HealthComponent/I-Frames"
	inventory_menu = gameNode.get_node("CanvasLayer").get_node("Inventory Menu")
	swap_timer = $"Weapon/Swap Timer"
	scenery = get_parent().get_node("scenery")
	audio_manager = self.get_tree().get_root().get_node("AudioManager")
	navigation_region_2d = $NavigationRegion2D
	timer = $NavigationRegion2D/Timer
	debug_timer = $"DEBUG TIMER"
	game = self.get_tree().get_root().get_node("Game")
	world = game.get_node("World")
	mobs = world.get_node("Mobs")
	inventory_menu.init_weapon_panels()
	hud.weapon_swap.init()
	weapon_swappable = true
	



func _physics_process(_delta):
	if Engine.time_scale == 1 && playable:
		read_inputs()
		player_health = health_component.health




func read_inputs():

#	if Input.is_action_just_pressed("add_weapon_test") && debug_avail:
#		mobs.bossWave()
#		debug_avail = false
#		debug_timer.start(1)
	
	
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#print(direction)
	direction_check()
	
	if direction && !audio_manager.sound_is_playing(sound_string, sound_info) && Engine.time_scale == 1 && sound_playable:
		sound_rng = randi_range(1, 3)
		if location == "hub":
			sound_string = "move_stone_" + str(sound_rng)
		else:
			sound_string = "move" + str(sound_rng)
		audio_manager.play_sound(sound_string, sound_info)
		sound_playable = false
		sound_timer.start(0.3)
	elif !direction || Engine.time_scale != 1:
		audio_manager.stop_sound(sound_string, sound_info)
	
	if location == "game":
		if Input.is_action_pressed("attack_primary"):
			if equipped_weapon && equipped_weapon.has_method("attack") && equipped_weapon.can_attack:
				equipped_weapon.attack()
				
		if Input.is_action_just_pressed("attack_secondary"):
			if equipped_weapon && equipped_weapon.has_method("attack_secondary") && equipped_weapon.can_attack:
				equipped_weapon.attack_secondary()
		
		if Input.is_action_pressed("weapon_swap") && weapon_swappable:
			weapon_swap()
	
	velocity = direction * speed
	move_and_slide()

func direction_check():
	var mousePosition = get_global_mouse_position()
	var angle = global_position.angle_to_point(mousePosition)
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
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

func gain_exp(value):
	player_exp += value
	if player_exp >= player_levelup_xp:
		player_levelup_xp += (player_levelup_xp * 0.3)
		hud.XP_BAR_MAX = player_levelup_xp
		hud.exp_bar.set_max(player_levelup_xp)
		level_up()

func gain_health(value):
	if player_health + value > health_component.MAX_HEALTH:
		health_component.health = health_component.MAX_HEALTH
		player_health = health_component.MAX_HEALTH
	else:
		health_component.health += value
		player_health += value

func gain_currency(value, type):
	if type == "coin": 
		player_coins += value
		StaticData.player_info.currency.coin += value
	elif type == "crystal": 
		player_crystal += value
		StaticData.player_info.currency.crystal += value

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

func stat_upgrade(new_upgrade):
	#print(new_upgrade)
	var new_level = player_upgrades[new_upgrade]["current_level"]
	
	#
	# player upgrades
	#
	if new_upgrade == "hp_up": perma_upgrade_health = player_upgrades[new_upgrade]["level"][str(new_level)]
	elif new_upgrade == "damage_up": perma_upgrade_damage = player_upgrades[new_upgrade]["level"][str(new_level)]
	elif new_upgrade == "attack_speed_up": perma_upgrade_attack_speed = player_upgrades[new_upgrade]["level"][str(new_level)]
	elif new_upgrade == "speed_up": perma_upgrade_speed = player_upgrades[new_upgrade]["level"][str(new_level)]
	#
	# follower upgrades
	#
	elif new_upgrade == "follower_damage": perma_upgrade_follower_damage = player_upgrades[new_upgrade]["level"][str(new_level)]
	elif new_upgrade == "follower_attack_speed": perma_upgrade_follower_attack_speed = player_upgrades[new_upgrade]["level"][str(new_level)]
	#
	# etc
	#
	
	init_stats()

func weapon_add(weapon_type, slot):
	if weapon_type != null:
		if slot == 1:
			var new_equipped_weapon
			if weapon_type == "Empty Wizard's Staff": new_equipped_weapon = staff_weapon.instantiate()
			elif weapon_type == "Magical Components": new_equipped_weapon = magic_component_weapon.instantiate()
			elif weapon_type == "Old Spell Book":     new_equipped_weapon = spell_book_weapon.instantiate()
			elif weapon_type == "Wizard's Gun":       new_equipped_weapon = gun_weapon.instantiate()
			weapon.call("add_child", new_equipped_weapon)
			equipped_weapon = new_equipped_weapon
		elif slot == 2:
			var new_holstered_weapon
			if weapon_type == "Empty Wizard's Staff": new_holstered_weapon = staff_weapon.instantiate()
			elif weapon_type == "Magical Components": new_holstered_weapon = magic_component_weapon.instantiate()
			elif weapon_type == "Old Spell Book":     new_holstered_weapon = spell_book_weapon.instantiate()
			elif weapon_type == "Wizard's Gun":       new_holstered_weapon = gun_weapon.instantiate()
			weapon.call("add_child", new_holstered_weapon)
			holstered_weapon = new_holstered_weapon
			holstered_weapon.set_visible(false)
	else: print("Weapon Not Found!")

func weapon_swap():
	
	weapon_swappable = false
	
	if holstered_weapon != null && equipped_weapon != null:
		audio_manager.play_sound("hurt", sound_info)
		var temp_weapon = equipped_weapon
		var new_equipped_weapon = holstered_weapon
		#weapon.call("add_child", new_equipped_weapon)
		#equipped_weapon.queue_free()
		equipped_weapon = new_equipped_weapon
		equipped_weapon.set_visible(true)
		holstered_weapon = temp_weapon
		holstered_weapon.set_visible(false)
		inventory_menu.swap_weapons()
		hud.weapon_swap.init()
		swap_timer.start(1)

#if Input.is_action_pressed("weapon_swap") && weapon_swappable:
#		weapon_swappable = false
#		var new_weapon
#		if equipped_weapon.WEAPON_NAME == "gun":
#			new_weapon = melee_weapon
#		elif equipped_weapon.WEAPON_NAME == "staff":
#			new_weapon = ranged_weapon
#
#		var temp_weapon = equipped_weapon
#		var new_equipped_weapon = new_weapon.instantiate()
#		weapon.call("add_child", new_equipped_weapon)
#		equipped_weapon.queue_free()
#		equipped_weapon = new_equipped_weapon
#		holstered_weapon = temp_weapon
#		inventory_menu.swap_weapons()
#		hud.weapon_swap.init()
#		swap_timer.start(1)
		

func _on_i_frames_timeout():
	health_component.INVINCIBLE = false

func _on_swap_timer_timeout():
	weapon_swappable = true

func _on_sound_timer_timeout():
	sound_playable = true

func _on_timer_timeout():
	pass

func _on_debug_timer_timeout():
	debug_avail = true

func _on_debug_timer_2_timeout():
	pass
	#print("player health: ", player_health)
	#print("player pos: ", global_position)
