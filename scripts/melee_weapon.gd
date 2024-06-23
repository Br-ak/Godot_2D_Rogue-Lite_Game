extends Area2D
const WEAPON_NAME = "staff"

@onready var player = get_parent().get_parent().get_parent().get_node("Player")
@onready var animSprite = $Marker2D/AnimatedSprite2D
@onready var animPlayer = $Marker2D/AnimatedSprite2D/AnimationPlayer
@onready var hitbox = $Marker2D/AnimatedSprite2D/hitbox/CollisionShape2D
@onready var timer = $Timer
@onready var timer_2 = $Timer2
@onready var marker_2d = $Marker2D
@onready var shooting_point = %ShootingPoint
@onready var area_2d = $"."
@onready var primary_attack_sfx = $primary_attack_sfx
@onready var secondary_attack_sfx = $secondary_attack_sfx


var mousePosition : Vector2
var can_attack = true
var baseDamage = 5
@onready var primary_attack_base_wait = animPlayer.get_animation("primary_attack").length
@onready var secondary_attack_base_wait = animPlayer.get_animation("secondary_attack").length
var currentDamage = baseDamage
var local_mouse_position : Vector2
var adjusted_mouse_position : Vector2
var attack_over = false
var charging = true
var button_released = false
const projectile = preload("res://tscn/staff-projectile.tscn")
var primary_attack
var secondary_attack

func _ready():
	init_attacks()
	hitbox.disabled = true
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Engine.time_scale == 1:
		getMousePosition()
		if Input.is_action_just_released("attack_secondary"):
			button_released = true

func getMousePosition():
	mousePosition = get_global_mouse_position()
	
	if mousePosition.x > player.position.x: ##### looking right
		marker_2d.scale.x = 1
		look_at(mousePosition)
	elif mousePosition.x < player.position.x: ##### looking left
		# adjusted mouse position should return inverted mousePosition
		# coupled with the marker's x value being inverted it should mirror any animation in the animation player
		# no need to created 2 animations for each attack
		local_mouse_position = (mousePosition - global_position)
		adjusted_mouse_position = global_position - local_mouse_position
		marker_2d.scale.x = -1
		look_at(adjusted_mouse_position)

func attack():
	if can_attack:
		can_attack = false
		hitbox.disabled = false
		animPlayer.play("primary_attack")
		primary_attack_sfx.play()
		await animPlayer.animation_finished
		hitbox.disabled = true
		timer.start(primary_attack_base_wait * primary_attack.attack_reset_time_multiplier)

func attack_secondary():
	attack_over = false
	if can_attack and not animPlayer.is_playing():
		button_released = false
		can_attack = false
		animPlayer.play("secondary_attack")
		await animPlayer.animation_finished
		animPlayer.play("secondary_attack_charge")
		await animPlayer.current_animation_length
		timer_2.start(0.1)

func attack_secondary_fire():
	SharedFunctions.fire_projectile(projectile, get_tree().root, shooting_point, get_global_mouse_position(), secondary_attack)
	secondary_attack_sfx.play()
	animSprite.set_visible(false)
	timer.start(secondary_attack_base_wait * secondary_attack.attack_reset_time_multiplier)

func _on_hitbox_area_entered(area):
	if area is HitboxComponent:
		if area.get_parent().type == "Enemy":
			var newHitbox : HitboxComponent = area
			newHitbox.damage(primary_attack)

func _on_timer_timeout():
	if !animSprite.is_visible():
		animPlayer.play_backwards("Idle")
		animSprite.set_visible(true)
		animPlayer.play_backwards("Idle")
	timer.stop()
	can_attack = true

func _on_timer_2_timeout():
	if button_released && animPlayer.current_animation == "secondary_attack_charge":
		animPlayer.stop()
		attack_secondary_fire()
		button_released = false
		timer.start(secondary_attack_base_wait * secondary_attack.attack_reset_time_multiplier)
	else:
		timer_2.start(0.1)

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
	
