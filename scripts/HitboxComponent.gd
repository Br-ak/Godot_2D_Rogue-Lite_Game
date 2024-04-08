extends Area2D
class_name HitboxComponent

@export var health_component : HealthComponent
var collision

func damage(attack: Attack):
	if health_component:
		health_component.damage(attack)

func death():
	print("here")
	collision.set_deferred("disabled", true)
