extends Area2D

@onready var player = get_parent().get_parent().get_parent().get_node("Player")
@onready var animSprite = $Marker2D/AnimatedSprite2D
@onready var animPlayer = $Marker2D/AnimatedSprite2D/AnimationPlayer
@onready var hitbox = $Marker2D/AnimatedSprite2D/hitbox/CollisionShape2D
@onready var timer = $Timer
@onready var timer_2 = $Timer2
@onready var marker_2d = $Marker2D
@onready var shooting_point = %ShootingPoint
@onready var area_2d = $"."

var mousePosition : Vector2
var can_attack = true
var baseDamage = 5
var currentDamage = baseDamage
var local_mouse_position : Vector2
var adjusted_mouse_position : Vector2
var attack_speed_mod = 1
var attack_over = false
var charging = true
var button_released = false
const projectile = preload("res://tscn/staff-projectile.tscn")

func _ready():
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
		await animPlayer.animation_finished
		hitbox.disabled = true
		timer.start(animPlayer.get_animation("primary_attack").length * attack_speed_mod)

func attack_secondary():
	attack_over = false
	if can_attack and not animPlayer.is_playing():
		button_released = false
		can_attack = false
		#print("fire start")
		animPlayer.play("secondary_attack")
		await animPlayer.animation_finished
		animPlayer.play("secondary_attack_charge")
		await animPlayer.current_animation_length
		
		timer_2.start(0.1)
		#print("fire end")

func attack_secondary_fire():
	var projectile_count = 3
	var offset_distance := 10.0
	var prev_projectile_position : Vector2
	var prev_projectile_rotation : float
	var direction_vector : Vector2 #Vector2(0, -) upwards direction, Vector2(0, +) downwards direction
	var rotation_radians : float
	var above_direction_variable
	var below_direction_variable
	if projectile_count % 2 == 0: # even projectile count
		above_direction_variable = -0.5
		below_direction_variable = 0.5
		for i in range(1, projectile_count + 2):
			var new_projectile = projectile.instantiate()
			if !prev_projectile_position:
				new_projectile.global_position = shooting_point.global_position
				new_projectile.look_at(get_global_mouse_position())
				prev_projectile_rotation = new_projectile.rotation_degrees
				prev_projectile_position = new_projectile.position
			elif prev_projectile_position:
				if i % 2 == 0:
					direction_vector = Vector2(0, above_direction_variable) # Upwards direction
					above_direction_variable -= 1
				else:
					direction_vector = Vector2(0, below_direction_variable) # Downwards direction
					below_direction_variable += 1
				rotation_radians = deg_to_rad(prev_projectile_rotation)
				direction_vector = direction_vector.rotated(rotation_radians)
				new_projectile.position = prev_projectile_position + direction_vector * offset_distance
				new_projectile.rotation_degrees = prev_projectile_rotation
				get_tree().root.add_child(new_projectile)
	else: # odd projectile count
		above_direction_variable = -1
		below_direction_variable = 1
		for i in range(1, projectile_count + 1):
			var new_projectile = projectile.instantiate()
			if !prev_projectile_position:
				new_projectile.global_position = shooting_point.global_position
				new_projectile.look_at(get_global_mouse_position())
				prev_projectile_rotation = new_projectile.rotation_degrees
				prev_projectile_position = new_projectile.position
			elif prev_projectile_position:
				if i % 2 == 0:
					direction_vector = Vector2(0, above_direction_variable) # Upwards direction
					above_direction_variable -= 1
				else:
					direction_vector = Vector2(0, below_direction_variable) # Downwards direction
					below_direction_variable += 1
				rotation_radians = deg_to_rad(prev_projectile_rotation)
				direction_vector = direction_vector.rotated(rotation_radians)
				new_projectile.position = prev_projectile_position + direction_vector * offset_distance
				new_projectile.rotation_degrees = prev_projectile_rotation
			get_tree().root.add_child(new_projectile)
	animSprite.set_visible(false)
	timer.start(animPlayer.get_animation("secondary_attack").length * attack_speed_mod)

func _on_hitbox_area_entered(area):
	if area is HitboxComponent:
		if area.get_parent().type == "Enemy":
			var newHitbox : HitboxComponent = area
			var newAttack = Attack.new()
			newAttack.attack_damage = currentDamage
			newHitbox.damage(newAttack)

func _on_timer_timeout():
	if !animSprite.is_visible():
		animPlayer.play_backwards("Idle")
		animSprite.set_visible(true)
		animPlayer.play_backwards("Idle")
	#print("timer end")
	timer.stop()
	can_attack = true

func _on_timer_2_timeout():
	if button_released && animPlayer.current_animation == "secondary_attack_charge":
		animPlayer.stop()
		attack_secondary_fire()
		button_released = false
		timer.start(animPlayer.get_animation("secondary_attack").length * attack_speed_mod)
	else:
		timer_2.start(0.1)
