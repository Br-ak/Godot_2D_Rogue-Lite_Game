extends CharacterBody2D

var speed = 200  # speed in pixels/sec
@onready var anim = $AnimatedSprite2D
var frameCount = 0
var background_tiles = null
var allow_attack = true
var attack_type = 1
var can_attack = true
@export var ammo : PackedScene
@onready var weapon = $Weapon
@onready var timer = $Weapon/Timer

func _ready():
	anim.play("Side_Idle")

func _physics_process(_delta):
	read_inputs()

func read_inputs():
	if Input.is_action_pressed("shoot"):
		if weapon.has_method("shoot"):
			if can_attack:
				weapon.shoot()
				can_attack = false
				timer.start(0.25)
		if weapon.has_method("melee"):
			if can_attack:
				weapon.melee()
				can_attack = false
				timer.start(0.25)

	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

		
	var mousePosition = get_global_mouse_position()
	var angle = position.angle_to_point(mousePosition)

	if angle > -0.78 and angle < 0.78: #####looking right
		anim.scale.x = 1
		if direction: #player has movement
			anim.play("Side_Move")
		else: #No movement
			anim.play("Side_Idle")
	elif angle > 2.34 or angle < -2.34: #####looking left
		anim.scale.x = -1
		if direction: #player has movement
			anim.play("Side_Move")
		else: #No movement
			anim.play("Side_Idle")
	elif angle > 0.78 and angle < 2.34: #####looking up
		anim.scale.x = 1
		if direction: #player has movement
			anim.play("Down_Move")
		else: #No movement
			anim.play("Down_Idle")
	elif angle > -2.34 and angle < -0.78: #####looking down
		anim.scale.x = 1
		if direction: #player has movement
			anim.play("Up_Move")
		else: #No movement
			anim.play("Up_Idle")



	velocity = direction * speed
	move_and_slide()

func _on_timer_timeout():
	can_attack = true
	print("can shoot")
