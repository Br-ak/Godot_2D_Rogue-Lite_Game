extends Area2D

var SPEED = 50
@onready var player = get_parent().get_parent().get_node("Player")
var amount := 0
@onready var sprite_2d = $Sprite2D
var drop
var coin_texture = preload("res://assets/visual/upgrades/currency_coin.png")
var crystal_texture = preload("res://assets/visual/upgrades/currency_mana.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	var drop_type = rng.randi_range(0,100)
	if drop_type < 50:
		amount = rng.randi_range(5,50)
		drop = "coin"
		sprite_2d.set_texture(coin_texture)
	else:
		amount = rng.randi_range(5,25)
		drop = "crystal"
		sprite_2d.set_texture(crystal_texture)
	#sprite_2d.scale = Vector2(3, 3)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_body_entered(body):
	if body.has_method("gain_currency"):
		body.gain_currency(amount, drop)
		self.queue_free()
