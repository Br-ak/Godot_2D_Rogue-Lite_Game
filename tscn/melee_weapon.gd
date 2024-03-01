extends Area2D

@onready var player = get_parent().get_parent().get_node("Player")
@onready var anim = $Marker2D/AnimatedSprite2D


func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(get_global_mouse_position())
	if get_global_mouse_position().x > player.position.x:
		anim.scale.y = 1
		anim.scale.x = 1
	elif get_global_mouse_position().x < player.position.x:
		anim.scale.y = -1
		anim.scale.x = -1
