extends Area2D
class_name HitboxComponent

@export var health_component : HealthComponent
@export var parent : CharacterBody2D
@onready var hitbox = $CollisionShape2D
@onready var parent_collision = parent.get_node("CollisionShape2D")
#This collision shape is used only for damage/hit detection

func damage(attack: Attack):
	if health_component:
		health_component.damage(attack)

func death(_attack: Attack):
	# for some reason just disabling the hitbox doesnt work, so it gets removed
	hitbox.queue_free()
	parent_collision.queue_free()
