extends Area2D

@onready var player = get_parent().get_parent().get_parent().get_node("Player")
@onready var anim = $Marker2D/AnimatedSprite2D
@onready var timer = $Timer
@onready var shooting_point = %ShootingPoint
@onready var primary_attack_sfx = $primary_attack_sfx

var can_attack = true
var attack_wait = 0.20
const BULLET = preload("res://tscn/bullets.tscn")
const WEAPON_NAME = "gun"
var primary_attack : Attack
var secondary_attack : Attack

func _ready():
	init_attacks()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Engine.time_scale == 1:
		look_at(get_global_mouse_position())
		if get_global_mouse_position().x > player.position.x:
			anim.scale.y = 1
		elif get_global_mouse_position().x < player.position.x:
			anim.scale.y = -1

func attack():
	if can_attack:
		can_attack = false
		var mouse_pos = get_global_mouse_position()
		SharedFunctions.fire_projectile(BULLET, get_tree().root, shooting_point, mouse_pos, primary_attack)
		primary_attack_sfx.play()
		timer.start(attack_wait)

func _on_timer_timeout():
	can_attack = true

func init_attacks():
	var attack_list = SharedFunctions.init_attacks(WEAPON_NAME)
	if attack_list[0] is String: print("No attacks found")
	elif attack_list.size() == 1: # 1 atttack found
		primary_attack = attack_list[0]
		primary_attack.update_attack_damage()
	elif attack_list.size() == 2: # 2 atttacks found
		primary_attack = attack_list[0]
		secondary_attack = attack_list[1]
		primary_attack.update_attack_damage()
		secondary_attack.update_attack_damage()

func update_attacks(upgrade_list, attack_to_update):
	if attack_to_update == 1:
		primary_attack = SharedFunctions.update_attacks(upgrade_list, primary_attack)
	elif attack_to_update == 2:
		secondary_attack = SharedFunctions.update_attacks(upgrade_list, secondary_attack)
