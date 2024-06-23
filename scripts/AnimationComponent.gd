extends Node2D
class_name AnimationComponent

@onready var anim = $AnimatedSprite2D
@export var health_component : HealthComponent

func _ready():
	anim.play("Run")

func hurt(_attack: Attack):
	anim.play("Hurt")
	await anim.animation_finished
	anim.play("Run")

func death(_attack: Attack):
	get_node("AnimatedSprite2D").play("Death")
	await get_node("AnimatedSprite2D").animation_finished
	get_parent().queue_free()
