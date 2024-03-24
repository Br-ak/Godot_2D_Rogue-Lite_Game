extends Area2D

var travelled_distance = 0
@onready var SPEED = 500

func _physics_process(delta):
	
	const RANGE = 1200
	var direction = Vector2.RIGHT.rotated(rotation)
	
	position += direction * SPEED * delta # delta means time dependent rather than frame dependent
	
	travelled_distance += SPEED * delta
	if travelled_distance > RANGE:
		queue_free()

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(10)
		queue_free()
