extends Node2D

var Enemy_Bot = preload("res://tscn/enemy_bot.tscn")
@onready var player = get_parent().get_node("Player")
@onready var game = self.get_tree().get_root().get_node("Game")
@onready var hud = game.get_node("CanvasLayer").get_node("Hud")
@onready var timer = $Timer
@onready var timer_2 = $Timer2

var playerPOS
var boss_spawned = false
var counter = 0
var BOSS_SPAWN_COUNT = 75
var new_location




func _ready():
	timer.start(2)



func _on_timer_timeout():
	spawnWave(10)
	# every 100 enemies spawn a boss
	if player.killCounter > counter + BOSS_SPAWN_COUNT:
		counter += BOSS_SPAWN_COUNT
		boss_spawned =  true
		var new_location = get_location()
		var enemyTemp = Enemy_Bot.instantiate()
		enemyTemp.position = Vector2(new_location[0], new_location[1])
		enemyTemp.scale *= 3
		var enemyTemp_health_comp = enemyTemp.get_node("HealthComponent")
		enemyTemp_health_comp.MAX_HEALTH = 100
		call_deferred("add_child", enemyTemp)
		hud.alert_message("Boss Spawned!")

func spawnWave(waveSize):
	hud.alert_message("Wave Spawned!")
	for i in range(waveSize):
		new_location = get_location()
		spawnGroupInClump(2, new_location[0], new_location[1])
	timer.start(25)

func spawnGroup(groupSize, location):
	for i in range(groupSize):
		#var new_location = get_location()
		var enemyTemp = Enemy_Bot.instantiate()
		enemyTemp.global_position = Vector2(location[0] + (i), location[1])
		#enemyTemp.global_position = Vector2(new_location[0], new_location[1])
		call_deferred("add_child", enemyTemp)

func spawnGroupInClump(groupSize, x, y, min_distance = 2, max_distance = 5):
	for i in range(groupSize):
		var offset = get_random_offset(min_distance, max_distance)
		var enemy_position = Vector2(x, y) + offset
		spawnEnemy(enemy_position)

func spawnEnemy(position):
	var enemyTemp = Enemy_Bot.instantiate()
	enemyTemp.global_position = position
	call_deferred("add_child", enemyTemp)

func relocateEnemy(enemy):
	new_location = get_location()
	
	enemy.global_position = Vector2(new_location[0], new_location[1])

func get_random_offset(min_distance, max_distance):
	var rng = RandomNumberGenerator.new()
	var angle = rng.randf_range(0, 2 * PI)
	var distance = rng.randf_range(min_distance, max_distance)
	return Vector2(cos(angle), sin(angle)) * distance


func get_location():
	playerPOS = player.get_global_position()
	var viewport_size = get_viewport().size
	var half_width = viewport_size.x / 2
	var half_height = viewport_size.y / 2
	var screen_left = playerPOS.x - half_width
	var screen_right = playerPOS.x + half_width
	var screen_top = playerPOS.y - half_height
	var screen_bottom = playerPOS.y + half_height
	
	var rng = RandomNumberGenerator.new()
	var variation_x
	var variation_y
	var variation_side = rng.randi_range(1,4)
	var weighted_rng = rng.randi_range(1, 3)
	if weighted_rng == 1: # 1/5 chance to spawn enemy in players movement direction
		var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		if direction.x > 1: variation_side = 2
		elif direction.x < 1: variation_side = 1
		elif direction.y > 1: variation_side = 4
		elif direction.y < 1: variation_side = 3
	
	if variation_side == 1:   # left
		#print("left")
		variation_x = rng.randi_range(screen_left, screen_left - 10) 
		variation_y = rng.randi_range(screen_bottom + 10,screen_top + 10)
	elif variation_side == 2: # right
		#print("right")
		variation_x = rng.randi_range(screen_right , screen_right + 10) 
		variation_y = rng.randi_range(screen_bottom + 10,screen_top + 10)
	elif variation_side == 3: # top
		print("top")
		variation_x = rng.randi_range(screen_left - 10, screen_right + 10) 
		variation_y = rng.randi_range(screen_top, screen_top + 10) 
	elif variation_side == 4: # bottom
		variation_x = rng.randi_range(screen_left - 10, screen_right + 10)
		variation_y = rng.randi_range(screen_bottom, screen_bottom - 10) 
	
	return [variation_x, variation_y]
