extends Control


@onready var dialog_box = self.get_parent().get_node("Dialog Box")
@onready var context_menu = self.get_parent().get_node("context_menu")
@onready var player = self.get_parent().get_parent().get_node("Player")
@onready var player_camera = self.get_parent().get_parent().get_node("Player").get_node("Camera2D")
@onready var hub = self.get_parent().get_parent()
														
														
@onready var tutorial = $"."
@onready var nine_patch_rect = $NinePatchRect
@onready var button = $Button
@onready var button_2 = $Button2
@onready var pan_timer = $pan_timer
@onready var timer = $Button/Timer
@onready var exit_timer = $"Button3/exit timer"
														
														
@onready var t_1 = $T1
@onready var t_1_img = $T1/t_1_img
@onready var t_1_texture_rect = $T1/t_1_img/TextureRect
@onready var t_1_nine_patch_rect = $T1/NinePatchRect
@onready var t_1_texture_rect_2 = $T1/NinePatchRect/TextureRect
@onready var t_1_nine_patch_rect_2 = $T1/NinePatchRect2
@onready var t_1_label = $T1/NinePatchRect2/t_1_label
														
														
														
@onready var t_2 = $T2
@onready var t_2_img = $T2/t_2_img
@onready var t_2_texture_rect = $T2/t_2_img/t_2_TextureRect
@onready var t_2_nine_patch_rect = $T2/t_2_NinePatchRect
@onready var t_2_texture_rect_2 = $T2/t_2_NinePatchRect/t_2_TextureRect_2
@onready var t_2_nine_patch_rect_2 = $T2/t_2_NinePatchRect2
@onready var t_2_label = $T2/t_2_NinePatchRect2/t_2_label
														
														
@onready var t_3 = $T3
@onready var t_3_nine_patch_rect = $T3/t_3_NinePatchRect
@onready var t_3_texture_rect_2 = $T3/t_3_NinePatchRect/t_3_TextureRect_2
@onready var t_3_nine_patch_rect_2 = $T3/t_3_NinePatchRect2
@onready var t_3_label = $T3/t_3_NinePatchRect2/t_3_label
														
														
@onready var t_4 = $T4
@onready var t_5 = $T5
@onready var t_6 = $T6






var player_set_pos = Vector2(0, -100)
var blacksmith_offset = Vector2(-400, -50)
var seer_offset = Vector2(-50, -150)
var chest_offset = Vector2(125, -75)
var exit_offset = Vector2(50, -100)

var button_pressable := true
var timer_use := "camera"
var player_dist_to_start
var cam_distance
var pan_duration := 1.0 # Duration of the pan in seconds
var elapsed_time := 0.0
var pan_to
var target
var original_camera_offset
var pan_complete := false
var step := 0
var exit_type := "rude_exit"

func init():
	original_camera_offset = player_camera.offset
	player.playable = false
	player_pos_pan()
	# first dialogue
	context_menu.set_visible(false)
	player.anim.play("Side_Idle")
	dialog_box.fetch_text("Satyr Steve", "tutorial_text", "intro")
	tutorial.set_visible(true)
	reset_visibility()

func reset_visibility():
	for node in tutorial.get_children():
		if node is Control:
			if node.name == "Button2" || node.name == "Button3":
				node.set_visible(true)
			else:
				node.set_visible(false)

func player_pos_pan():
	player_dist_to_start = player.position
	timer_use = "player"
	elapsed_time = 0.0
	pan_timer.start(0.1)

func _on_pan_timer_timeout():
	pan_complete = false
	if timer_use == "player":
		elapsed_time += pan_timer.wait_time
		var t = elapsed_time / 0.5
		player.position = lerp(player_dist_to_start, player_set_pos, t)
		
		if t >= 1.0:
			pan_timer.stop()
			player.playable = false
	elif timer_use == "camera":
		if pan_to == "blacksmith": target = blacksmith_offset
		elif pan_to == "seer": target = seer_offset
		elif pan_to == "chest": target = chest_offset
		elif pan_to == "exit": target = exit_offset
		elif pan_to == "player": target = original_camera_offset
		elapsed_time += pan_timer.wait_time
		var t = elapsed_time / pan_duration
		player_camera.offset = lerp(cam_distance, target, t)
		
		if t >= 1.0:
			pan_timer.stop()
			player.playable = false
			pan_complete = true

func camera_pan():
	cam_distance = player_camera.offset
	timer_use = "camera"
	elapsed_time = 0.0
	pan_timer.start(0.1)

func _on_button_pressed():
	if button_pressable:
		button_pressable = false
		if step == 1:
			timer.stop()
			pan_to = "seer"
			camera_pan()
			dialog_box.fetch_text("Satyr Steve", "tutorial_text", "seer_1")
		elif step == 2:
			timer.stop()
			dialog_box.fetch_text("Satyr Steve", "tutorial_text", "seer_2")
			t_1.set_visible(true)
			nine_patch_rect.set_visible(true)
			button_2.set_visible(true)
		elif step == 3:
			reset_visibility()
			timer.stop()
			pan_to = "blacksmith"
			camera_pan()
			dialog_box.fetch_text("Satyr Steve", "tutorial_text", "blacksmith_1")
		elif step == 4:
			timer.stop()
			dialog_box.fetch_text("Satyr Steve", "tutorial_text", "blacksmith_2")
			t_2.set_visible(true)
			nine_patch_rect.set_visible(true)
			button_2.set_visible(true)
		elif step == 5:
			reset_visibility()
			timer.stop()
			pan_to = "chest"
			camera_pan()
			dialog_box.fetch_text("Satyr Steve", "tutorial_text", "chest_1")
		elif step == 6:
			timer.stop()
			dialog_box.fetch_text("Satyr Steve", "tutorial_text", "chest_2")
			t_3.set_visible(true)
			nine_patch_rect.set_visible(true)
			button_2.set_visible(true)
		elif step == 7:
			reset_visibility()
			timer.stop()
			pan_to = "exit"
			camera_pan()
			dialog_box.fetch_text("Satyr Steve", "tutorial_text", "exit_1")
		elif step == 8:
			timer.stop()
			dialog_box.fetch_text("Satyr Steve", "tutorial_text", "exit_2")
		elif step == 9:
			reset_visibility()
			timer.stop()
			pan_to = "player"
			camera_pan()
			dialog_box.fetch_text("Satyr Steve", "tutorial_text", "game_1")
		elif step == 10:
			timer.stop()
			dialog_box.fetch_text("Satyr Steve", "tutorial_text", "game_2")
			t_4.set_visible(true)
			nine_patch_rect.set_visible(true)
			button_2.set_visible(true)
		elif step == 11:
			reset_visibility()
			timer.stop()
			t_5.set_visible(true)
			nine_patch_rect.set_visible(true)
			button_2.set_visible(true)
			dialog_box.fetch_text("Satyr Steve", "tutorial_text", "game_3")
		elif step == 12:
			reset_visibility()
			t_6.set_visible(true)
			timer.stop()
			dialog_box.fetch_text("Satyr Steve", "tutorial_text", "gems_1")
		elif step == 13:
			timer.stop()
			dialog_box.fetch_text("Satyr Steve", "tutorial_text", "gems_2")
		elif step == 14:
			timer.stop()
			dialog_box.fetch_text("Satyr Steve", "tutorial_text", "gems_3")
		elif step == 15:
			reset_visibility()
			timer.stop()
			dialog_box.fetch_text("Satyr Steve", "tutorial_text", "outro_1")
			exit_type = "normal_exit"
		elif step == 16:
			_on_button_3_pressed()
		step += 1
	if timer.is_stopped():
		timer.start(1.5)

func _on_timer_timeout():
	#print(step)
	button_pressable = true


func _on_button_3_pressed():
	for node in tutorial.get_children():
		if node is Control:
			node.set_visible(false)
	tutorial.set_visible(false)
	dialog_box.fetch_text("Satyr Steve", "tutorial_text", exit_type)
	exit_timer.start(2)


func _on_exit_timer_timeout():
	exit_timer.stop()
	player_camera.offset = Vector2(0, 0)
	dialog_box.set_visible(false)
	player.playable = true
	hub.can_interact = true
