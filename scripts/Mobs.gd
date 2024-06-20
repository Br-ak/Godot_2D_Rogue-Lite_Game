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
		playerPOS = player.get_global_position()
		var rng = RandomNumberGenerator.new()
		var pinX = rng.randi_range(playerPOS.x + 0,playerPOS.x + 100)
		var pinY = rng.randi_range(playerPOS.y + 0,playerPOS.y + 100)
		var variation = rng.randi_range(0,50)
		var enemyTemp = Enemy_Bot.instantiate()
		enemyTemp.position = Vector2(pinX + variation, pinY + variation)
		enemyTemp.scale *= 3
		var enemyTemp_health_comp = enemyTemp.get_node("HealthComponent")
		enemyTemp_health_comp.MAX_HEALTH = 100
		call_deferred("add_child", enemyTemp)
		await get_tree().create_timer(0.05).timeout
	spawnGroup(10)


func spawnWave(waveSize):
	for i in range(waveSize):
		pass


func spawnGroup(groupSize):
	playerPOS = player.get_global_position()
	var rng = RandomNumberGenerator.new()
	var pinX = rng.randi_range(playerPOS.x + 0,playerPOS.x + 100)
	var pinY = rng.randi_range(playerPOS.y + 0,playerPOS.y + 100)
	
	for i in range(groupSize):
		var variation = rng.randi_range(0,50)
		var enemyTemp = Enemy_Bot.instantiate()
		enemyTemp.position = Vector2(pinX + variation, pinY + variation)
		call_deferred("add_child", enemyTemp)
		await get_tree().create_timer(0.05).timeout
