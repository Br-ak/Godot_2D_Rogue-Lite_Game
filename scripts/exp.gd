extends Area2D

var SPEED = 50
@onready var player = get_parent().get_parent().get_node("Player")
var xp_gain := 10
@onready var sprite_2d = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_body_entered(body):
	if body.has_method("gain_exp"):
		body.gain_exp(xp_gain)
		queue_free()
