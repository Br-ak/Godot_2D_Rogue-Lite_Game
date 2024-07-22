extends Area2D

@onready var animSprite = $Marker2D/AnimatedSprite2D
@onready var animPlayer = $Marker2D/AnimatedSprite2D/AnimationPlayer
@onready var hitbox = $Marker2D/AnimatedSprite2D/hitbox/CollisionShape2D
@onready var timer = $Timer
@onready var marker_2d = $Marker2D
@onready var shooting_point = %ShootingPoint
@onready var area_2d = $"."

@onready var player = get_parent().get_parent().get_parent().get_node("Player")
@onready var audio_manager = self.get_tree().get_root().get_node("AudioManager")
@onready var primary_attack_base_wait = animPlayer.get_animation("primary_attack_1").length
@onready var secondary_attack_base_wait = animPlayer.get_animation("secondary_attack").length

const WEAPON_NAME = "spell book"
const projectile = preload("res://tscn/paper-projectile.tscn")
var sound_info = ["Magic Book Sounds"]
var mousePosition : Vector2
var can_attack = true
var local_mouse_position : Vector2
var adjusted_mouse_position : Vector2
var primary_attack
var secondary_attack


func _ready():
	init_attacks()
	hitbox.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Engine.time_scale == 1:
		getMousePosition()

func getMousePosition():
	mousePosition = get_global_mouse_position()
	if mousePosition.x > player.position.x: ##### looking right
		marker_2d.scale.x = 1
		look_at(mousePosition)
	elif mousePosition.x < player.position.x: ##### looking left
		local_mouse_position = (mousePosition - global_position)
		adjusted_mouse_position = global_position - local_mouse_position
		marker_2d.scale.x = -1
		look_at(adjusted_mouse_position)

func attack():
	if can_attack:
		can_attack = false
		hitbox.disabled = false
		animPlayer.play("primary_attack_1")
		audio_manager.play_sound("primary_attack", sound_info)
		await animPlayer.animation_finished
		hitbox.disabled = true
		
		timer.start(primary_attack_base_wait * primary_attack.attack_reset_time_multiplier)

func attack_secondary():
	can_attack = false
	animPlayer.play("secondary_attack")
	SharedFunctions.fire_projectile(projectile, get_tree().root, shooting_point, get_global_mouse_position(), secondary_attack)
	timer.start(secondary_attack_base_wait * secondary_attack.attack_reset_time_multiplier)
	
func _on_hitbox_area_entered(area):
	if area is HitboxComponent:
		if area.get_parent().type == "Enemy":
			var newHitbox : HitboxComponent = area
			newHitbox.damage(primary_attack)

func _on_timer_timeout():
	timer.stop()
	can_attack = true

func init_attacks():
	var attack_list = SharedFunctions.init_attacks(WEAPON_NAME)
	if attack_list[0] is String: print("No attacks found")
	elif attack_list.size() == 1: # 1 atttack found
		primary_attack = attack_list[0]
		primary_attack.update_attack_damage()
	elif attack_list.size() == 2: # 2 atttacks found
		primary_attack = attack_list[0]
		secondary_attack = attack_list[1]
		primary_attack.update_attack_damage()
		secondary_attack.update_attack_damage()

func update_attacks(upgrade_list, attack_to_update):
	if attack_to_update == 1:
		primary_attack = SharedFunctions.update_attacks(upgrade_list, primary_attack)
	elif attack_to_update == 2:
		secondary_attack = SharedFunctions.update_attacks(upgrade_list, secondary_attack)
