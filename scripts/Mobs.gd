extends Node2D

var Enemy_Bot = preload("res://tscn/enemy_bot.tscn")
@onready var player = get_parent().get_node("Player")

var playerPOS
var boss_spawned = false
var counter = 0
var BOSS_SPAWN_COUNT = 75

func _ready():
	pass

func _on_timer_timeout():
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
	spawnGroup(10)

func spawnWave(waveSize):
	for i in range(waveSize):
		pass

func spawnGroup(groupSize):
	for i in range(groupSize):
		var new_location = get_location()
		var enemyTemp = Enemy_Bot.instantiate()
		enemyTemp.global_position = Vector2(new_location[0], new_location[1])
		call_deferred("add_child", enemyTemp)
		await get_tree().create_timer(0.05).timeout

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
	var variation_side = rng.randi_range(1,4)
	var variation_x
	var variation_y
	
	if variation_side == 1:   # left
		variation_x = rng.randi_range(screen_left, screen_left - 10) 
		variation_y = rng.randi_range(screen_bottom + 10,screen_top + 10)
	elif variation_side == 2: # right
		variation_x = rng.randi_range(screen_right , screen_right + 10) 
		variation_y = rng.randi_range(screen_bottom + 10,screen_top + 10)
	elif variation_side == 3: # top
		variation_x = rng.randi_range(screen_left - 10, screen_right + 10) 
		variation_y = rng.randi_range(screen_top, screen_top + 10) 
	elif variation_side == 4: # bottom
		variation_x = rng.randi_range(screen_left - 10, screen_right + 10)
		variation_y = rng.randi_range(screen_bottom, screen_bottom - 10) 
	
	return [variation_x, variation_y]
