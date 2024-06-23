extends Node2D
class_name HealthComponent

@export var animation_component : AnimationComponent
@export var hitbox_component : HitboxComponent
@export var parent : CharacterBody2D
@export var MAX_HEALTH : float

var INVINCIBLE = false
var health : float
var dead = false

func _ready():
	health = MAX_HEALTH

func damage(attack: Attack):
	if INVINCIBLE == false:
		health -= attack.attack_damage
		if health > 0:
			if parent.has_method("hurt"):
				parent.hurt()
			if animation_component:
				animation_component.hurt(attack)
		elif health <= 0:
			if dead != true:
				if parent.has_method("death"):
					parent.death()
					dead = true
				if hitbox_component.has_method("death"):
					hitbox_component.death(attack)
				if animation_component:
					animation_component.death(attack)
