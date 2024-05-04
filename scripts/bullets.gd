extends Area2D

var travelled_distance = 0
@onready var SPEED = 500
var bullet_damage = 10

func _physics_process(delta):
	
	const RANGE = 1200
	var direction = Vector2.RIGHT.rotated(rotation)
	
	position += direction * SPEED * delta # delta means time dependent rather than frame dependent
	
	travelled_distance += SPEED * delta
	if travelled_distance > RANGE:
		queue_free()

func _on_hitbox_area_entered(area):
	if area is HitboxComponent:
		if area.get_parent().type == "Enemy":
			var hitbox : HitboxComponent = area
			var attack = Attack.new()
			attack.attack_damage = 5
			hitbox.damage(attack)
			self.queue_free()
