extends CharacterBody2D

var speed = 200  # speed in pixels/sec
@onready var anim = $AnimatedSprite2D
var frameCount = 0
var background_tiles = null
var allow_attack = true
var attack_type = 1
var can_shoot = true
@onready var player_hurtbox = $AnimatedSprite2D/Hurtbox/CollisionShape2D
@export var ammo : PackedScene
@onready var weapon = $Weapon
@onready var timer = $Weapon/Timer

func _ready():
	anim.play("Idle")

func _physics_process(_delta):
	read_inputs()

func read_inputs():
	if Input.is_action_pressed("shoot"):
		if weapon.has_method("shoot"):
			if can_shoot:
				weapon.shoot()
				can_shoot = false
				timer.start(0.25)

	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	if allow_attack:
		var attack = Input.is_action_pressed("player_attack")
		if attack:
			player_hurtbox.disabled = false
			allow_attack = false
			if attack_type == 1:
				anim.play("Attack1")
				attack_type = 2
			elif attack_type == 2:
				anim.play("Attack2")
				attack_type = 1
			await anim.animation_finished
			allow_attack = true
		else:
			if get_global_mouse_position().x > position.x:
				anim.scale.x = 1
			elif get_global_mouse_position().x < position.x:
				anim.scale.x = -1
			if direction:
				anim.play("Run")
			else:
				anim.play("Idle")
	player_hurtbox.disabled = true
	move_and_slide()

func _on_hurtbox_body_entered(body):
	if body.get_parent().name.contains("Mobs"):
		body.get_node("AnimatedSprite2D").play("Hurt")
		await body.get_node("AnimatedSprite2D").animation_finished
		body.get_node("AnimatedSprite2D").play("Run")
		body.health -= 5


func _on_timer_timeout():
	can_shoot = true
