extends CharacterBody2D

@onready var enemy = true
var SPEED = 25
var health = 10
@onready var player = get_parent().get_parent().get_node("Player")
@onready var hitbox = $CollisionShape2D
var frameCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("AnimatedSprite2D").play("Run")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	frameCount += 1
	if frameCount % 2 == 1:
		frameCount = 0
		var direction = (player.position - self.position).normalized() # Normalize the direction vector
		if health > 0:
			if direction.x > 0:
				get_node("AnimatedSprite2D").flip_h = false
			else:
				get_node("AnimatedSprite2D").flip_h = true
			velocity = direction * SPEED # Multiply the normalized direction by speed
			move_and_slide()

func take_damage(damage):
	health -= damage
	if health > 0:
		get_node("AnimatedSprite2D").play("Hurt")
		await get_node("AnimatedSprite2D").animation_finished
		get_node("AnimatedSprite2D").play("Run")
	else:
		death()

func death():
	hitbox.set_deferred("disabled", true)
	get_node("AnimatedSprite2D").play("Death")
	spawnExp()
	await get_node("AnimatedSprite2D").animation_finished
	self.queue_free()

func spawnExp():
	const EXP = preload("res://tscn/exp.tscn")
	var new_exp = EXP.instantiate()
	new_exp.global_position = self.global_position
	get_parent().call_deferred("add_child", new_exp)
