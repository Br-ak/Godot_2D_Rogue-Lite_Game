extends Area2D

var attack = Attack.new()

var hit_count = 0
var travelled_distance = 0
@onready var animated_sprite_2d = $Sprite2D
@onready var SPEED = attack.attack_projectile_speed
@onready var RANGE = attack.attack_range

const proj_1 = preload("res://assets/visual/weapon/magic_comp_proj_1.png")
const proj_2 = preload("res://assets/visual/weapon/magic_comp_proj_2.png")
const proj_3 = preload("res://assets/visual/weapon/magic_comp_proj_3.png")
const proj_4 = preload("res://assets/visual/weapon/magic_comp_proj_4.png")
const proj_5 = preload("res://assets/visual/weapon/magic_comp_proj_5.png")

func _ready():
	var rng = RandomNumberGenerator.new()
	var proj_num = rng.randi_range(1,5)
	if   proj_num == 1: animated_sprite_2d.set_texture(proj_1)
	elif proj_num == 2: animated_sprite_2d.set_texture(proj_2)
	elif proj_num == 3: animated_sprite_2d.set_texture(proj_3)
	elif proj_num == 4: animated_sprite_2d.set_texture(proj_4)
	elif proj_num == 5: animated_sprite_2d.set_texture(proj_5)
	else              : animated_sprite_2d.set_texture(proj_1)

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
