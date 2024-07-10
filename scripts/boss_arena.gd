extends Node2D
@onready var mobs = get_parent().get_parent().get_node("Mobs")
@onready var scenery = self.get_tree().get_root().get_node("Game").get_node("World").get_node("scenery")

@onready var boss_arena = $"."
@onready var boss_arena_location = $boss_arena_location
@onready var boss_interactable = $boss_arena_location/boss_interactable
@onready var interact_icon = $"boss_arena_location/boss_interactable/Interact Icon"
@onready var static_body_2d = $boss_arena_location/boss_interactable/StaticBody2D
@onready var collision_shape_2d = $boss_arena_location/boss_interactable/StaticBody2D/CollisionShape2D
@onready var shadow = $boss_arena_location/boss_interactable/shadow
@onready var no_spawn_zone = $boss_arena_location/no_spawn_zone
@onready var audio_manager = self.get_tree().get_root().get_node("AudioManager")
@onready var game = self.get_tree().get_root().get_node("Game")
@onready var hud = game.get_node("CanvasLayer").get_node("Hud")
@onready var player = game.get_node("World").get_node("Player")

var sound_info = ["Arena Sounds"]

# Called when the node enters the scene tree for the first time.
func _ready():
	collision_shape_2d.disabled = true
	interact_icon.collision_shape_2d.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.time_scale == 1:
		if interact_icon != null:
			if Input.is_action_pressed("player_interact") && interact_icon.player_interactable:
				boss_interactable_pressed()

func init(tile_pos):
	boss_arena_location.global_position = tile_pos
	boss_interactable.global_position = tile_pos + Vector2(35, 35)
	boss_interactable.set_visible(true)
	collision_shape_2d.disabled = false
	interact_icon.collision_shape_2d.disabled = false

func boss_interactable_pressed():
	player.arrow_pointer.pointer_active = false
	audio_manager.play_sound("interact", sound_info)
	audio_manager.play_music("BGM_boss", ["Music"])
	interact_icon.set_visible(false)
	interact_icon.collision_shape_2d.disabled = true
	mobs.boss_location = boss_arena_location.global_position + Vector2(0, -75)
	
	for mob in mobs.get_children():
		if mob is CharacterBody2D:
			mob.queue_free()
	var tile_pos = boss_arena_location.global_position
	var tilemap_pos = Vector2i(tile_pos.x / 16, tile_pos.y / 16)
	var lower_pattern_size = scenery.objects_lower.tile_set.get_pattern(11).get_size()
	var lower_offset = Vector2i(lower_pattern_size.x / 2, lower_pattern_size.y / 2)
	var lower_tile_pos = tilemap_pos - lower_offset
	
	scenery.objects_lower.set_pattern(0, lower_tile_pos, scenery.objects_lower.tile_set.get_pattern(11))
	hud.alert_message("Boss Incoming!")
	mobs.timer_3.start(5)

func boss_fight_over():
	
	mobs.boss_location = boss_arena_location.global_position
	interact_icon.set_visible(false)
	#interact_icon.collision_shape_2d.disabled = true
	interact_icon.collision_shape_2d.call_deferred("set_disabled", true)
	var tile_pos = boss_arena_location.global_position
	var tilemap_pos = Vector2i(tile_pos.x / 16, tile_pos.y / 16)
	var lower_pattern_size = scenery.objects_lower.tile_set.get_pattern(10).get_size()
	var lower_offset = Vector2i(lower_pattern_size.x / 2, lower_pattern_size.y / 2)
	var lower_tile_pos = tilemap_pos - lower_offset
	
	scenery.objects_lower.set_pattern(0, lower_tile_pos, scenery.objects_lower.tile_set.get_pattern(9))
	scenery.objects.set_pattern(0, lower_tile_pos, scenery.objects.tile_set.get_pattern(10))

func _on_no_spawn_zone_area_entered(area):
	if area is HitboxComponent:
		if area.get_parent().type == "Enemy":
			area.get_parent().bad_spawn = true

func _on_no_spawn_zone_area_exited(area):
	if area is HitboxComponent:
		if area.get_parent().type == "Enemy":
			area.get_parent().bad_spawn = false
