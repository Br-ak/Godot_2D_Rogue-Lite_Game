extends CharacterBody2D

@export var hitbox_component : HitboxComponent

@onready var player = get_parent().get_parent().get_node("Player")
@onready var follower = get_parent().get_parent().get_node("Follower")
@onready var anim = $AnimationComponent/AnimatedSprite2D
@onready var collision = $CollisionShape2D

var enemy = true
var SPEED = 25
var frameCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	frameCount += 1 
	if frameCount % 5 == 1: # once every 5 frames (multiple of 5)
		frameCount = 0
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

func death():
	follower.get("trackingList").erase(self) 
	collision.set_deferred("disabled", true)
	spawnExp()
	player.killCounter += 1

func spawnExp():
	const EXP = preload("res://tscn/exp.tscn")
	var new_exp = EXP.instantiate()
	new_exp.global_position = self.global_position
	get_parent().call_deferred("add_child", new_exp)
