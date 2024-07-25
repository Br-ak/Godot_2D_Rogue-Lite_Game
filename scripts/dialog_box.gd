extends Control

var char_max := 125
var text_to_display : String
var text_remaining := ""
var speaker_name := "..."
var speaker_icon_path 
var delay := 0.01 
var button_pressable = true
var sound_info = ["Npc Sounds"]
var talk1_name = ""
var menu_closed := false

@onready var dialog_box = $"."
@onready var texture_rect = $TextureRect
@onready var nine_patch_rect = $NinePatchRect
@onready var speaker = $NinePatchRect/speaker
@onready var message = $NinePatchRect/message
@onready var timer = $NinePatchRect/message/Timer
@onready var next_button = $NinePatchRect/next_button

@onready var data = StaticData.dialogue["dialogue"]
@onready var audio_manager = self.get_tree().get_root().get_node("AudioManager")


# Called when the node enters the scene tree for the first time.
func _ready():
	init_box()

func init_box():
	menu_closed = false
	message.text = ""
	speaker.text = speaker_name
	talk1_name = speaker_name + "_talk_1"
	if speaker_name != "...":
		speaker_icon_path = data[speaker_name]["portrait_icon_path"]
	if speaker_icon_path != null: 
		var texture = load(speaker_icon_path)
		texture_rect.set_texture(texture)
	message.text = "....."

func fetch_text(character, section, subsection):
	var fetched_text = data[character][section][subsection]
	message.text = fetched_text
	display_text(fetched_text)

func display_text(text):
	if text.length() > char_max:
		next_button.set_visible(true)
		var left_index = find_last_word(text.left(char_max))
		text_to_display = text.left(left_index)
		text_remaining = "... " + text.right(left_index * -1)
		display_text(text_to_display)
	else:
		if text_remaining == text: text_remaining = ""
		write_text_animated(text)

func write_text_animated(text):
	button_pressable = false
	message.text = ""
	for letter in text:
		if menu_closed == true:
			button_pressable = true
			text_remaining = ""
			text_to_display = ""
			break
		message.text += letter
		if speaker_name == "Satyr Steve":
			if !audio_manager.sound_is_playing("Satyr_talk_1", sound_info) && !audio_manager.sound_is_playing("Satyr_talk_2", sound_info) && !audio_manager.sound_is_playing("Satyr_talk_3", sound_info):
				var rand = randi_range(1,3)
				audio_manager.play_sound("Satyr_talk_" + str(rand), sound_info)
		else:
			audio_manager.play_sound(talk1_name, sound_info)
		await get_tree().create_timer(delay).timeout
		
	button_pressable = true

func find_last_word(text):
	var count = char_max - 1
	var not_found = true
	while not_found:
		var character = text[count]
		if character == " " || character == "." || character == ",":
			return count
			not_found = false
			break
		count -= 1

func _on_next_button_pressed():
	if button_pressable:
		button_pressable = false
		if text_remaining != "":
			display_text(text_remaining)
		else:
			close_dialogue()

func close_dialogue():
	#dialog_box.set_visible(false)
	if get_parent().get_parent().name == "Hub World":
		get_parent().get_parent().can_interact = true
		var rng = randi_range(1, 3)
		var intro_text = data[speaker_name]["intro"][str(rng)]
		display_text(intro_text)
	if get_parent().get_parent().has_node("Player"):
		get_parent().get_parent().get_node("Player").playable = true
