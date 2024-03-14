extends Area2D

@onready var player = get_parent().get_parent().get_parent().get_node("Player")
@onready var anim = $Marker2D/AnimatedSprite2D
@onready var anim_new = $Marker2D/AnimatedSprite2D/AnimationPlayer
@onready var hitbox = $Marker2D/AnimatedSprite2D/Area2D/CollisionShape2D

func _ready():
	hitbox.disabled = true
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(get_global_mouse_position())
	if get_global_mouse_position().x > player.position.x: ##### looking right
		anim.scale.y = 1
		anim.scale.x = -1
		anim.rotation = -45
	elif get_global_mouse_position().x < player.position.x: ##### looking left
		anim.scale.y = -1
		anim.scale.x = -1
		anim.rotation = 45
		
func attack():
	hitbox.disabled = false
	anim_new.play("Side_Attack")
	await anim_new.animation_finished
	hitbox.disabled = true


func _on_area_2d_body_entered(body):
	if body.get_parent().name.contains("Mobs"):
		if body.has_method("take_damage"):
			body.take_damage(5)
