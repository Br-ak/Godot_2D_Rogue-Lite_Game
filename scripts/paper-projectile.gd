extends Area2D

var attack = Attack.new()

var hit_count = 0
var travelled_distance = 0
const proj_1 = preload("res://assets/GUNS_V1.00/V1.00/PNG/magic_comp_proj_2.png")
const proj_2 = preload("res://assets/GUNS_V1.00/V1.00/PNG/paper_plane_projectile.png")

@onready var SPEED = attack.attack_projectile_speed
@onready var RANGE = attack.attack_range
@onready var sprite_2d = $Sprite2D
@onready var audio_manager = self.get_tree().get_root().get_node("AudioManager")
var sound_info = ["Magic Book Sounds"]

func _ready():
	var rng = RandomNumberGenerator.new()
	var proj_num = rng.randi_range(1,5)
	if   proj_num == 1: 
		sprite_2d.set_texture(proj_2)
		hit_count -= 10
		audio_manager.play_sound("secondary_attack_2", sound_info)
	else: 
		attack.attack_damage_increase = 5
		attack.update_attack_damage()
		sprite_2d.set_texture(proj_1)
		audio_manager.play_sound("secondary_attack_1", sound_info)

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
