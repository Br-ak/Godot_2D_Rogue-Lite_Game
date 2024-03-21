extends Node2D

var Enemy_Bot = preload("res://tscn/enemy_bot.tscn")
@onready var player = get_parent().get_node("Player")

var playerPOS

func _ready():
	pass

func _on_timer_timeout():
	spawnGroup(5)
#	for i in range(5):
#		var enemyTemp = Enemy_Bot.instantiate()
#		var rng = RandomNumberGenerator.new()
#		var randx = rng.randi_range(0,400)
#		var randy = rng.randi_range(0,400)
#		enemyTemp.position = Vector2(randx, randy)
#		call_deferred("add_child", enemyTemp)

func spawnWave(waveSize):
	for i in range(waveSize):
		pass


func spawnGroup(groupSize):
	playerPOS = player.get_position()
	var rng = RandomNumberGenerator.new()
	var randx = rng.randi_range(playerPOS.x + 0,playerPOS.x + 400)
	var randy = rng.randi_range(playerPOS.y + 0,playerPOS.y + 400)
	for i in range(groupSize):
		var enemyTemp = Enemy_Bot.instantiate()
		enemyTemp.position = Vector2(randx + (i * 10), randy)
		call_deferred("add_child", enemyTemp)
