extends Node2D

var Enemy_Bot = preload("res://tscn/enemy_bot.tscn")
@onready var player = get_parent().get_node("Player")

func _ready():
	pass

func _on_timer_timeout():
	for i in range(5):
		var enemyTemp = Enemy_Bot.instantiate()
		var rng = RandomNumberGenerator.new()
		var randx = rng.randi_range(0,400)
		var randy = rng.randi_range(0,400)
		enemyTemp.position = Vector2(randx, randy)
		#add_child(enemyTemp)
		call_deferred("add_child", enemyTemp)
