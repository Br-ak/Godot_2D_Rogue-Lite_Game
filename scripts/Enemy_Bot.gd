extends CharacterBody2D

@onready var enemy = true
var SPEED = 0.5
var health = 10
@onready var player = get_parent().get_parent().get_node("Player")
@onready var hitbox = $CollisionShape2D
var frameCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("AnimatedSprite2D").play("Run")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	frameCount +=1
	if(frameCount % 3 == 1):
		var direction = Vector2(player.position.x - self.position.x, player.position.y - self.position.y)
		if health > 0:
			if direction.x > 0:
				get_node("AnimatedSprite2D").flip_h = false
			else:
				get_node("AnimatedSprite2D").flip_h = true
			velocity.x = direction.x * SPEED
			velocity.y = direction.y * SPEED
			move_and_slide()
		else:
			death()

func damage():
	pass

func death():
	hitbox.disabled = true
	get_node("AnimatedSprite2D").play("Death")
	await get_node("AnimatedSprite2D").animation_finished
	self.queue_free()
