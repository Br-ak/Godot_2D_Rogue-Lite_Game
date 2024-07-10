extends Node2D

var Enemy_Bot = preload("res://tscn/enemy_bot.tscn")
@onready var player = get_parent().get_node("Player")
@onready var scenery = get_parent().get_node("scenery")
@onready var arena = scenery.get_node("boss_arena")
@onready var game = self.get_tree().get_root().get_node("Game")
@onready var hud = game.get_node("CanvasLayer").get_node("Hud")
@onready var timer = $Timer
@onready var timer_2 = $Timer2
@onready var timer_3 = $Timer3
@onready var audio_manager = self.get_tree().get_root().get_node("AudioManager")


var playerPOS
var boss_spawned = false
var counter = 0
var BOSS_SPAWN_COUNT = 100
var new_location
var boss_location : Vector2
var boss_wave = false


func _ready():
	timer.start(2)
	timer_2.start(2)



func _on_timer_timeout():
	if !audio_manager.sound_is_playing("BGM_battle", ["Music"]):
		audio_manager.play_music("BGM_battle", ["Music"])
	
	if !boss_wave: 
		if player.killCounter > counter + BOSS_SPAWN_COUNT:
			print("count: ", BOSS_SPAWN_COUNT)
			counter += BOSS_SPAWN_COUNT
			BOSS_SPAWN_COUNT += (BOSS_SPAWN_COUNT * 0.3)
			print("count: ", BOSS_SPAWN_COUNT)
			bossWave()
		else:
			spawnWave(5)

func bossWave():
	boss_wave = true
	timer.stop()
	timer_2.stop()
	#audio_manager.play_music("BGM_boss", ["Music"])
	await scenery.spawn_boss_arena()
	hud.alert_message("Boss Arena Spawned!")

func spawnBoss(location):
	timer_3.stop()
	if !boss_spawned:
		boss_spawned =  true
		var enemyTemp = Enemy_Bot.instantiate()
		enemyTemp.global_position = location
		enemyTemp.scale *= 3
		enemyTemp.SPEED = 50
		enemyTemp.boss = true
		var enemyTemp_health_comp = enemyTemp.get_node("HealthComponent")
		enemyTemp_health_comp.MAX_HEALTH = 200
		enemyTemp_health_comp.health = 200
		call_deferred("add_child", enemyTemp)
		hud.alert_message("Boss Spawned!")

func bossSlain():
	arena.boss_fight_over()
	audio_manager.stop_sound("BGM_boss", ["Music"])
	timer.start(2)
	timer_2.start(2)
	boss_spawned = false
	boss_wave = false
	

func spawnWave(waveSize):
	#hud.alert_message("Wave Spawned!")
	for i in range(waveSize):
		new_location = SharedFunctions.get_location()
		while SharedFunctions.is_conflicting(new_location):
			new_location = SharedFunctions.get_location()
		spawnGroupInClump(5, new_location[0], new_location[1])
	timer.start(25)

func spawnGroup(groupSize, location):
	for i in range(groupSize):
		var enemyTemp = Enemy_Bot.instantiate()
		enemyTemp.global_position = Vector2(location[0] + (i), location[1])
		call_deferred("add_child", enemyTemp)

func spawnGroupInClump(groupSize, x, y, min_distance = 2, max_distance = 5):
	for i in range(groupSize):
		var offset = get_random_offset(min_distance, max_distance)
		var enemy_position = Vector2(x, y) + offset
		spawnEnemy(enemy_position)

func spawnEnemy(position):
	if position != null:
		var enemyTemp = Enemy_Bot.instantiate()
		enemyTemp.global_position = position
		while SharedFunctions.is_conflicting(enemyTemp.global_position):
			new_location = SharedFunctions.get_location()
			enemyTemp.global_position = Vector2(new_location[0], new_location[1])
		enemyTemp.SPEED = randi_range(55, 65)
		call_deferred("add_child", enemyTemp)
		if enemyTemp.bad_spawn:
			relocateEnemy(enemyTemp)

func relocateEnemy(enemy):
	new_location = SharedFunctions.get_location()
	while SharedFunctions.is_conflicting(new_location):
			new_location = SharedFunctions.get_location()
	enemy.global_position = Vector2(new_location[0], new_location[1])
	
	if enemy.bad_spawn:
		#print("bad spawn, relocating...")
		var mod = randi_range(100, 400)
		enemy.global_position += Vector2(mod, mod)
		enemy.bad_spawn = false

func get_random_offset(min_distance, max_distance):
	var rng = RandomNumberGenerator.new()
	var angle = rng.randf_range(0, 2 * PI)
	var distance = rng.randf_range(min_distance, max_distance)
	return Vector2(cos(angle), sin(angle)) * distance

func _on_timer_2_timeout():
	#trickle smaller amounts of enemies constantly for variety
	if !boss_wave:
		for i in range(0, 1):
			new_location = SharedFunctions.get_location()
			new_location = Vector2(new_location[0], new_location[1])
			spawnEnemy(new_location)
		timer_2.start(1)

func _on_timer_3_timeout():
	spawnBoss(boss_location)
