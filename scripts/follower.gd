extends CharacterBody2D

var SPEED = 5
@onready var player = get_parent().get_node("Player")
@onready var anim = $AnimationPlayer
var preVelocity = Vector2(0, 0)


func _physics_process(_delta):
	var direction = Vector2(player.position.x - self.position.x, player.position.y - self.position.y)
	if velocity == preVelocity:
		anim.play("Idle")
	else:
		anim.play("Run")
	if(self.position.distance_to(player.position) > 40):
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED
		move_and_slide()
	preVelocity = velocity
