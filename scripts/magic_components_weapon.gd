extends Area2D

const projectile = preload("res://tscn/magic_components_projectile.tscn")
const WEAPON_NAME = "magic components"



@onready var player = get_parent().get_parent().get_parent().get_node("Player")
@onready var anim = $AnimatedSprite2D
@onready var anim2 = $Marker2D/AnimatedSprite2D2
@onready var timer = $Timer
@onready var timer_2 = $Timer2
@onready var timer_3 = $Timer3

@onready var shooting_point = %ShootingPoint
@onready var marker_2d = $Marker2D
@onready var audio_manager = self.get_tree().get_root().get_node("AudioManager")
@onready var animPlayer = $Marker2D/AnimatedSprite2D2/AnimationPlayer

var sound_info = ["Magic Components Sounds"]
var can_attack = true
var attack_base_wait = 0.50
var mousePosition
var primary_attack : Attack
var secondary_attack : Attack # not in use
var button_released = false
var local_mouse_position
var adjusted_mouse_position
var charge_count = 0
var temp_attack_projectile_count
var temp_attack_range
var charge_counter = 0

func _ready():
	init_attacks()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	mousePosition = get_global_mouse_position()
	if Engine.time_scale == 1:
		if Input.is_action_just_released("attack_primary"): 
			button_released = true
		
		if player.direction_facing == "right" && anim.position.x > 0:
			anim.position.x *= -1
			anim.rotation *= -1
			
		elif player.direction_facing == "left" && anim.position.x < 0:
			anim.position.x *= -1
			anim.rotation *= -1
			
		if player.direction_facing == "down":
				anim.z_index = -1
				anim2.z_index = -1
		else:
				anim.z_index = 1
				anim2.z_index = 1
			

		
		
		getMousePosition()

func getMousePosition():
	mousePosition = get_global_mouse_position()
	
	if mousePosition.x > player.position.x: ##### looking right
		marker_2d.scale.x = 1
		if can_attack: marker_2d.look_at(mousePosition)
	elif mousePosition.x < player.position.x: ##### looking left
		# adjusted mouse position should return inverted mousePosition
		# coupled with the marker's x value being inverted it should mirror any animation in the animation player
		# no need to created 2 animations for each attack
		local_mouse_position = (mousePosition - global_position)
		adjusted_mouse_position = global_position - local_mouse_position
		marker_2d.scale.x = -1
		if can_attack: marker_2d.look_at(adjusted_mouse_position)

func attack():
	if can_attack and !animPlayer.is_playing():
		button_released = false
		can_attack = false
		animPlayer.play("primary_start")
		await animPlayer.animation_finished
		animPlayer.play("primary_charge")
		await animPlayer.current_animation_length
		timer_2.start(0.1)
		timer_3.start(0.3)
		charge_counter = 0

func _on_timer_2_timeout():
	if button_released && animPlayer.current_animation == "primary_charge":
		timer_3.stop()
		animPlayer.stop()
		attack_fire()
		button_released = false
		timer.start(attack_base_wait * primary_attack.attack_reset_time_multiplier)
	else:
		timer_2.start(0.1)

func attack_fire():
	animPlayer.play("primary_toss")
	SharedFunctions.fire_projectile(projectile, get_tree().root, shooting_point, get_global_mouse_position(), primary_attack)
	if temp_attack_projectile_count != primary_attack.attack_projectile_count:
		primary_attack.attack_projectile_count = temp_attack_projectile_count
		primary_attack.attack_range = temp_attack_range
	audio_manager.play_sound("primary_toss", sound_info)
	timer.start(attack_base_wait * primary_attack.attack_reset_time_multiplier)

func _on_timer_timeout():
	timer.stop()
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
	temp_attack_projectile_count = primary_attack.attack_projectile_count
	temp_attack_range = primary_attack.attack_range

func update_attacks(upgrade_list, attack_to_update):
	if attack_to_update == 1:
		primary_attack = SharedFunctions.update_attacks(upgrade_list, primary_attack)
	elif attack_to_update == 2:
		secondary_attack = SharedFunctions.update_attacks(upgrade_list, secondary_attack)

func _on_timer_3_timeout():
	if button_released && animPlayer.current_animation == "primary_charge":
		timer_3.stop()
	else:
		if !audio_manager.sound_is_playing("primary_charge", sound_info):
			audio_manager.play_sound("primary_charge", sound_info)
			if charge_counter > 1 && primary_attack.attack_projectile_count < 5:
				audio_manager.play_sound("primary_charge_tick", sound_info)
				charge_counter = 0
				primary_attack.attack_projectile_count += 1
				primary_attack.attack_range += 25
			else:
				charge_counter += 1
			timer_3.start(0.3)
