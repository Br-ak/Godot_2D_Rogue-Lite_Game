extends Area2D

@onready var player = get_parent().get_parent().get_parent().get_node("Player")
@onready var anim = $Marker2D/AnimatedSprite2D
@onready var anim_new = $Marker2D/AnimatedSprite2D/AnimationPlayer
@onready var hitbox = $Marker2D/AnimatedSprite2D/hitbox/CollisionShape2D
var mousePosition

@onready var hud = get_parent().get_parent().get_parent().get_node("Control")

var killCounter := 0:
	set(value):
		killCounter = value
		hud.killCounter = killCounter

func _ready():
	hitbox.disabled = true
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	mousePosition = get_global_mouse_position()
	look_at(mousePosition)
	if mousePosition.x > player.position.x: ##### looking right
		anim.scale.y = 1
		anim.scale.x = -1
		anim.rotation = -45
	elif mousePosition.x < player.position.x: ##### looking left
		anim.scale.y = -1
		anim.scale.x = -1
		anim.rotation = 45

func attack():
	hitbox.disabled = false
	anim_new.play("Side_Attack")
	await anim_new.animation_finished
	hitbox.disabled = true

#func _on_area_2d_body_entered(body):
#	if body.get("enemy"):
#		if body.has_method("take_damage"):
#			var attack = Attack.new()
#			attack.attack_damage = 5
#			body.take_damage(attack)
#			if body.health < 1:
#				killCounter += 1




func _on_hitbox_area_entered(area):
	if area is HitboxComponent:
		var hitbox : HitboxComponent = area
		var attack = Attack.new()
		
		attack.attack_damage = 5
		
		hitbox.damage(attack)
