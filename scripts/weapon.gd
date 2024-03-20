extends Area2D

@onready var player = get_parent().get_parent().get_parent().get_node("Player")
@onready var anim = $Marker2D/AnimatedSprite2D


func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	look_at(get_global_mouse_position())
	if get_global_mouse_position().x > player.position.x:
		anim.scale.y = 1
	elif get_global_mouse_position().x < player.position.x:
		anim.scale.y = -1
		
func shoot():
	const BULLET = preload("res://tscn/bullets.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.global_rotation = %ShootingPoint.global_rotation
	%ShootingPoint.add_child(new_bullet)
