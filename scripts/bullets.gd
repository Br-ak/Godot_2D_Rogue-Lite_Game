extends Area2D

var attack = Attack.new()

var hit_count = 0
var travelled_distance = 0
@onready var animated_sprite_2d = $Sprite2D
@onready var SPEED = attack.attack_projectile_speed
@onready var RANGE = attack.attack_range

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	
	position += direction * SPEED * delta # delta means time dependent rather than frame dependent
	travelled_distance += SPEED * delta
	if travelled_distance > RANGE:
		queue_free()

func _on_hitbox_area_entered(area):
	if area is HitboxComponent:
		if area.get_parent().type == "Enemy":
			hit_count += 1
			var hitbox : HitboxComponent = area
			hitbox.damage(attack)
			if (hit_count >= attack.attack_pierce):
				self.queue_free()
