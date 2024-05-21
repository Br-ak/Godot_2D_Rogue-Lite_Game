extends Area2D

@onready var player = get_parent().get_parent().get_parent().get_node("Player")
@onready var animSprite = $Marker2D/AnimatedSprite2D
@onready var animPlayer = $Marker2D/AnimatedSprite2D/AnimationPlayer
@onready var hitbox = $Marker2D/AnimatedSprite2D/hitbox/CollisionShape2D
@onready var timer = $Timer
@onready var marker_2d = $Marker2D

var mousePosition : Vector2
var can_attack = true
var baseDamage = 5
var currentDamage = baseDamage
var local_mouse_position : Vector2
var adjusted_mouse_position : Vector2
var attack_speed_mod = 1

func _ready():
	hitbox.disabled = true
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Engine.time_scale == 1:
		if can_attack:
			getMousePosition()

func getMousePosition():
	mousePosition = get_global_mouse_position()

	
	if mousePosition.x > player.position.x: ##### looking right
		marker_2d.scale.x = 1
		look_at(mousePosition)
	elif mousePosition.x < player.position.x: ##### looking left
		# adjusted mouse position should return inverted mousePosition
		# coupled with the marker's x value being inverted it should mirror any animation in the animation player
		# no need to created 2 animations for each attack
		local_mouse_position = (mousePosition - global_position)
		adjusted_mouse_position = global_position - local_mouse_position
		marker_2d.scale.x = -1
		look_at(adjusted_mouse_position)

func attack():
	if can_attack:
		can_attack = false
		hitbox.disabled = false
		animPlayer.play("primary_attack")
		await animPlayer.animation_finished
		hitbox.disabled = true
		timer.start(animPlayer.get_animation("primary_attack").length * attack_speed_mod)

func _on_hitbox_area_entered(area):
	if area is HitboxComponent:
		if area.get_parent().type == "Enemy":
			var newHitbox : HitboxComponent = area
			var newAttack = Attack.new()
			newAttack.attack_damage = currentDamage
			newHitbox.damage(newAttack)


func _on_timer_timeout():
	can_attack = true
