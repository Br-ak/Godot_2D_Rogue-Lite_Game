extends CharacterBody2D

@export var hitbox_component : HitboxComponent

@onready var player = get_parent().get_parent().get_node("Player")
@onready var mobs = get_parent()
@onready var anim = $AnimationComponent/AnimatedSprite2D
@onready var collision = $CollisionShape2D
@onready var off_screen_timer = $"Off Screen Timer"
@onready var audio_manager = self.get_tree().get_root().get_node("AudioManager")
@onready var navigation_agent_2d = $NavigationAgent2D
@onready var timer = $NavigationAgent2D/Timer
@onready var boss_sfx_timer = $boss_sfx_Timer
@onready var health_component = $HealthComponent

@onready var scenery = get_parent().get_parent().get_node("scenery")
@onready var game = self.get_tree().get_root().get_node("Game")
@onready var hud = game.get_node("CanvasLayer").get_node("Hud")

var boss_health := 0:
	set(value):
		boss_health = value
		hud.boss_health = boss_health

var sound_info = ["Bot Sounds"]
const type = "Enemy"
var boss := false
var baseDamage = 5
var currentDamage = baseDamage
var enemy = true
var SPEED = 65
var acceleration = 7
var ON_SCREEN = true
var bad_spawn = false
#var direction

# Called when the node enters the scene tree for the first time.
func _ready():
	if boss:
		hud.boss_health_bar_control.set_visible(true)
		boss_sfx_timer.start(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if boss:
		boss_health = health_component.health
	# handle off screen logic
	if is_off_screen(global_position):
		if collision != null:
			collision.set_deferred("disabled", true)
		set_visible(false)
		if off_screen_timer.is_stopped():
			off_screen_timer.start(4)
	else:
		set_visible(true)
		if collision != null:
			collision.set_deferred("disabled", false)
		if off_screen_timer:
			off_screen_timer.stop()
	
	#var direction = (player.position - self.position).normalized() # Normalize the direction vector
	var direction = Vector2.ZERO
	direction = navigation_agent_2d.get_next_path_position() - global_position
	direction = direction.normalized()
	
	
	if anim.get_animation() != "Death" && anim.get_animation() != "Hurt" : # Pauses movement when specific animations are played
		if direction.x > 0:
			anim.flip_h = false
		else:
			anim.flip_h = true
		velocity = velocity.lerp(direction * SPEED, acceleration * delta)
		move_and_slide()

func create_path():
	navigation_agent_2d.target_position = player.global_position

func _on_timer_timeout():
	create_path()

func attack():
	pass

func hurt():
	audio_manager.play_sound("hurt", sound_info)

func death():
	audio_manager.play_sound("hurt", sound_info)
	if boss == true:
		mobs.bossSlain()
		audio_manager.play_sound("boss death", sound_info)
		hud.boss_health_bar_control.set_visible(false)
	else:
		audio_manager.play_sound("death", sound_info)
		
	collision.set_deferred("disabled", true)
	var follower = get_parent().get_parent().get_node("Follower")
	if follower:
		follower.get("trackingList").erase(self) 
	var rng = RandomNumberGenerator.new()
	var xp_rng = rng.randi_range(0,100)
	if xp_rng % 5 == 0 || boss: # 20% spawn rate for xp drop
		spawnExp()
	else:
		var health_pot_rng = rng.randi_range(0,200)
		if health_pot_rng % 5 == 0 || boss: # 20% spawn rate for health drop if no xp drop
			spawnHealthPotion()
	player.killCounter += 1
	player.gain_exp(1)
	

func spawnExp():
	const EXP = preload("res://tscn/exp.tscn")
	var new_exp = EXP.instantiate()
	new_exp.global_position = self.global_position
	
	get_parent().call_deferred("add_child", new_exp)
	if boss:
		new_exp.xp_gain = 100

func spawnHealthPotion():
	const HEALTH = preload("res://tscn/health_potion.tscn")
	var new_health = HEALTH.instantiate()
	new_health.global_position = self.global_position
	get_parent().call_deferred("add_child", new_health)
	

func _on_hitbox_component_area_entered(area):
	if area is HitboxComponent:
		if area.get_parent().type == "Player":
			var hitbox : HitboxComponent = area
			var newAttack = Attack.new()
			newAttack.attack_damage = currentDamage
			hitbox.damage(newAttack)

func is_off_screen(enemy_position: Vector2) -> bool:
	var viewport_size = get_viewport().size
	var player_position = player.global_position
	
	var half_width = viewport_size.x / 2
	var half_height = viewport_size.y / 2
	
	var screen_left = player_position.x - half_width
	var screen_right = player_position.x + half_width
	var screen_top = player_position.y - half_height
	var screen_bottom = player_position.y + half_height
	
	return (enemy_position.x < screen_left 
			or enemy_position.x > screen_right 
			or enemy_position.y < screen_top 
			or enemy_position.y > screen_bottom)


func _on_off_screen_timer_timeout():
	# may be wise to simply move enemy to a closer area instead
	mobs.relocateEnemy(self)


func _on_boss_sfx_timer_timeout():
	audio_manager.play_sound("boss growl", sound_info)
	var sound_timer = randi_range(3, 7)
	boss_sfx_timer.start(sound_timer)
