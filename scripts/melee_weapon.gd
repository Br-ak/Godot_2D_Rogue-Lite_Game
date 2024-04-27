extends Area2D

@onready var player = get_parent().get_parent().get_parent().get_node("Player")
@onready var animSprite = $Marker2D/AnimatedSprite2D
@onready var animPlayer = $Marker2D/AnimatedSprite2D/AnimationPlayer
@onready var hitbox = $Marker2D/AnimatedSprite2D/hitbox/CollisionShape2D
var mousePosition

func _ready():
	hitbox.disabled = true
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	mousePosition = get_global_mouse_position()
	look_at(mousePosition)
	if mousePosition.x > player.position.x: ##### looking right
		animSprite.scale.y = 1
		animSprite.scale.x = -1
		animSprite.rotation = -45
	elif mousePosition.x < player.position.x: ##### looking left
		animSprite.scale.y = -1
		animSprite.scale.x = -1
		animSprite.rotation = 45

func attack():
	hitbox.disabled = false
	animPlayer.play("Side_Attack")
	await animPlayer.animation_finished
	hitbox.disabled = true

func _on_hitbox_area_entered(area):
	if area is HitboxComponent:
		var hitbox : HitboxComponent = area
		var attack = Attack.new()
		attack.attack_damage = 5
		hitbox.damage(attack)
