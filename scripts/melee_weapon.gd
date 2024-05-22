extends Area2D

@onready var player = get_parent().get_parent().get_parent().get_node("Player")
@onready var animSprite = $Marker2D/AnimatedSprite2D
@onready var animPlayer = $Marker2D/AnimatedSprite2D/AnimationPlayer
@onready var hitbox = $Marker2D/AnimatedSprite2D/hitbox/CollisionShape2D
@onready var timer = $Timer
@onready var marker_2d = $Marker2D
@onready var shooting_point = %ShootingPoint

var mousePosition : Vector2
var can_attack = true
var baseDamage = 5
var currentDamage = baseDamage
var local_mouse_position : Vector2
var adjusted_mouse_position : Vector2
var attack_speed_mod = 1

const projectile = preload("res://tscn/staff-projectile.tscn")

func _ready():
	hitbox.disabled = true
	pass

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
	if can_attack:
		can_attack = false
		animPlayer.play("secondary_attack")
		await animPlayer.animation_finished
		animPlayer.play("secondary_attack_charge")
		attack_secondary_fire()

func attack_secondary_fire():
	var new_projectile = projectile.instantiate()
	new_projectile.global_position = shooting_point.global_position
	new_projectile.global_rotation = shooting_point.global_rotation
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
	can_attack = true
	if !animSprite.is_visible():
		animPlayer.play("Idle")
		animSprite.set_visible(true)
