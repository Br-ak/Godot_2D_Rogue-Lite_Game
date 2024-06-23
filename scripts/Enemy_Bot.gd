extends CharacterBody2D

@export var hitbox_component : HitboxComponent

@onready var player = get_parent().get_parent().get_node("Player")
@onready var anim = $AnimationComponent/AnimatedSprite2D
@onready var collision = $CollisionShape2D
@onready var death_sfx = $death_sfx
@onready var hurt_sfx = $hurt_sfx
@onready var off_screen_timer = $"Off Screen Timer"

const type = "Enemy"
var baseDamage = 5
var currentDamage = baseDamage
var enemy = true
var SPEED = 25
var ON_SCREEN = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	# handle off screen logic
	if is_off_screen(global_position):
		if collision != null:
			collision.set_deferred("disabled", true)
		set_visible(false)
		if off_screen_timer.is_stopped():
			off_screen_timer.start(10)
	else:
		set_visible(true)
		if collision != null:
			collision.set_deferred("disabled", false)
		if off_screen_timer:
			off_screen_timer.stop()
	
	var direction = (player.position - self.position).normalized() # Normalize the direction vector
	if anim.get_animation() != "Death" && anim.get_animation() != "Hurt" : # Pauses movement when specific animations are played
		if direction.x > 0:
			anim.flip_h = false
		else:
			anim.flip_h = true
		velocity = direction * SPEED # Multiply the normalized direction by speed
		move_and_slide()

func attack():
	pass

func hurt():
	hurt_sfx.play()

func death():
	collision.set_deferred("disabled", true)
	hurt_sfx.play()
	var follower = get_parent().get_parent().get_node("Follower")
	if follower:
		follower.get("trackingList").erase(self) 
	var rng = RandomNumberGenerator.new()
	var xp_rng = rng.randi_range(0,100)
	if xp_rng % 5 == 0: # 20% spawn rate for xp drop
		spawnExp()
	player.killCounter += 1
	player.gain_exp(1)
	death_sfx.play()

func spawnExp():
	const EXP = preload("res://tscn/exp.tscn")
	var new_exp = EXP.instantiate()
	new_exp.global_position = self.global_position
	get_parent().call_deferred("add_child", new_exp)

func _on_hitbox_component_area_entered(area):
	if area is HitboxComponent:
		if area.get_parent().type == "Player":
			var hitbox : HitboxComponent = area
			var newAttack = Attack.new()
			newAttack.attack_damage = currentDamage
			hitbox.damage(newAttack)

func is_off_screen(enemy_position: Vector2) -> bool:
	var viewport_size = get_viewport().size
	var player_position = player.global_position
	
	var half_width = viewport_size.x / 2
	var half_height = viewport_size.y / 2
	
	var screen_left = player_position.x - half_width
	var screen_right = player_position.x + half_width
	var screen_top = player_position.y - half_height
	var screen_bottom = player_position.y + half_height
	
	return (enemy_position.x < screen_left 
			or enemy_position.x > screen_right 
			or enemy_position.y < screen_top 
			or enemy_position.y > screen_bottom)


func _on_off_screen_timer_timeout():
	# may be wise to simply move enemy to a closer area instead
	self.queue_free()
