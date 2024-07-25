extends CharacterBody2D

var SPEED = 5
@onready var player = get_parent().get_node("Player")
@onready var anim = $AnimationPlayer
@onready var timer = $Timer
var reloadTime = 2
var preDirection = Vector2(0, 0)
var trackingList = []
var canShoot = true

var perma_upgrade_attack_speed := 0.0
var perma_upgrade_attack_damage := 0

func _physics_process(_delta):
	var direction = Vector2(player.position.x - self.position.x, player.position.y - self.position.y)
	if direction != preDirection:
		anim.play("Run")
	else:
		anim.play("Idle")
	if(self.position.distance_to(player.position) > 40):
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED
		move_and_slide()
	preDirection = direction
	
	if trackingList.size() > 0 && canShoot:
		attack()


func attack():
	var closestEnemy
	
	for b in trackingList: 
		if b != null:
			var distance = b.global_position.distance_to(self.global_position)
			if closestEnemy == null:
				closestEnemy = [b, distance]
			else:
				if distance < closestEnemy[1]: # compare distances
					closestEnemy = [b, distance]
	
	if trackingList.size() < 1:
		closestEnemy = null
	if closestEnemy != null && Engine.time_scale == 1:
		shoot(closestEnemy)


func shoot(closestEnemy):
	const BULLET = preload("res://tscn/bullets.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = self.global_position
	var direction_to_enemy = closestEnemy[0].global_position - self.global_position
	var angle_to_enemy = direction_to_enemy.angle()
	new_bullet.global_rotation = angle_to_enemy
	self.add_child(new_bullet)
	new_bullet.attack.attack_damage_increase += perma_upgrade_attack_damage
	perma_upgrade_attack_speed /= 100
	new_bullet.attack.attack_reset_time_multiplier -= perma_upgrade_attack_speed
	new_bullet.attack.update_attack_damage()
	canShoot = false
	timer.start(reloadTime * new_bullet.attack.attack_reset_time_multiplier)


func _on_range_body_entered(body):
	if body.get("enemy"):
		if !trackingList.has(body):
			trackingList.append(body)

func _on_timer_timeout():
	canShoot = true
