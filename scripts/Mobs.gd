extends Node2D

var Enemy_Bot = preload("res://tscn/enemy_bot.tscn")
@onready var player = get_parent().get_node("Player")
@onready var scenery = get_parent().get_node("scenery")
@onready var game = self.get_tree().get_root().get_node("Game")
@onready var hud = game.get_node("CanvasLayer").get_node("Hud")
@onready var timer = $Timer
@onready var timer_2 = $Timer2
@onready var timer_3 = $Timer3
@onready var audio_manager = self.get_tree().get_root().get_node("AudioManager")

var playerPOS
var boss_spawned = false
var counter = 0
var BOSS_SPAWN_COUNT = 15
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
			counter += BOSS_SPAWN_COUNT
			bossWave()
		else:
			spawnWave(5)

func bossWave():
	boss_wave = true
	print("boss wave...")
	timer.stop()
	timer_2.stop()
	hud.alert_message("Boss Incoming!")
	audio_manager.play_music("BGM_boss", ["Music"])
	boss_location = player.global_position
	scenery.spawn_boss_arena()
	timer_3.start(5)

func spawnBoss():
	timer_3.stop()
	boss_spawned =  true
	var enemyTemp = Enemy_Bot.instantiate()
	enemyTemp.position = boss_location
	enemyTemp.scale *= 3
	enemyTemp.SPEED = 50
	enemyTemp.boss = true
	var enemyTemp_health_comp = enemyTemp.get_node("HealthComponent")
	enemyTemp_health_comp.MAX_HEALTH = 200
	call_deferred("add_child", enemyTemp)
	hud.alert_message("Boss Spawned!")

func bossSlain():
	audio_manager.stop_sound("BGM_boss", ["Music"])
	timer.start(2)
	timer_2.start(2)
	boss_spawned = false
	boss_wave = false

func spawnWave(waveSize):
	hud.alert_message("Wave Spawned!")
	for i in range(waveSize):
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
	var enemyTemp = Enemy_Bot.instantiate()
	enemyTemp.global_position = position
	enemyTemp.SPEED = randi_range(55, 65)
	call_deferred("add_child", enemyTemp)

func relocateEnemy(enemy):
	new_location = SharedFunctions.get_location()
	
	enemy.global_position = Vector2(new_location[0], new_location[1])

func get_random_offset(min_distance, max_distance):
	var rng = RandomNumberGenerator.new()
	var angle = rng.randf_range(0, 2 * PI)
	var distance = rng.randf_range(min_distance, max_distance)
	return Vector2(cos(angle), sin(angle)) * distance





func _on_timer_2_timeout():
	#trickle smaller amounts of enemies constantly for variety
	for i in range(0, 1):
		new_location = SharedFunctions.get_location()
		new_location = Vector2(new_location[0], new_location[1])
		spawnEnemy(new_location)
	timer_2.start(1)



func _on_timer_3_timeout():
	spawnBoss()
