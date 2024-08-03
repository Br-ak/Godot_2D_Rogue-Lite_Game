extends Node
@onready var audio_manager = $"."

# Player Sounds
@onready var player_sounds = $"Player Sounds"
@onready var music = $Music

# Function to change the volume level for a list of AudioStreamPlayers
func set_audio_level(audio_nodes: Array, volume_db: float):
	for node in audio_nodes:
		if node is AudioStreamPlayer:
			node.set_volume_db(volume_db)

# Main function to change audio levels
func change_audio_level(audio_data):
	var master_volume_db = linear_to_db(audio_data[0])
	var music_volume_db = linear_to_db(audio_data[1])
	var sfx_volume_db = linear_to_db(audio_data[2])
	
	# music nodes
	var music_nodes = []
	for node in music.get_children():
		if node is AudioStreamPlayer:
			music_nodes.append(node)
	set_audio_level(music_nodes, music_volume_db)
	
	# SFX nodes
	var sfx_nodes = []
	for nodes in audio_manager.get_children():
		if nodes.name != "Music":
			for node in nodes.get_children():
				if node is AudioStreamPlayer:
					sfx_nodes.append(node)
	set_audio_level(sfx_nodes, sfx_volume_db)
	
	# master
	for nodes in audio_manager.get_children():
		for node in nodes.get_children():
			if node is AudioStreamPlayer:
				var current_db = node.get_volume_db()
				node.set_volume_db(current_db + master_volume_db)

# Want to keep separate in case music is handled differently later
func play_music(music_name: String, music_data):
	if audio_manager.has_node(music_data[0]):
		var sound_node_group = self.get_node(music_data[0])
		if sound_node_group.has_node(music_name):
			var sound_node = sound_node_group.get_node(music_name)
			if sound_node is AudioStreamPlayer:

				# stop other playing music nodes
				for music_node in sound_node_group.get_children():
					if music_node != null && music_node.is_playing():
						music_node.stop()
				sound_node.play()
		else:
			print("Error: Music not found - " + music_name)
	else:
		print("Error: Group not found")


#sound_data = [group name, ]
func play_sound(sound_name: String, sound_data):
	if audio_manager.has_node(sound_data[0]):
		var sound_node_group = self.get_node(sound_data[0])
		if sound_node_group.has_node(sound_name):
			var sound_node = sound_node_group.get_node(sound_name)
			if sound_node is AudioStreamPlayer:
				sound_node.play()
		else:
			print("Error: Sound not found - " + sound_name)
	else:
		print("Error: Group not found")


func stop_sound(sound_name: String, sound_data):
	if audio_manager.has_node(sound_data[0]):
		var sound_node_group = self.get_node(sound_data[0])
		if sound_node_group.has_node(sound_name):
			var sound_node = sound_node_group.get_node(sound_name)
			if sound_node is AudioStreamPlayer:
				sound_node.stop()
			else:
				print("Error: Node is not an AudioStreamPlayer - " + sound_name)
		else:
			print("Error: Sound not found - " + sound_name)


func sound_is_playing(sound_name: String, sound_data):
	if audio_manager.has_node(sound_data[0]):
		var sound_node_group = self.get_node(sound_data[0])
		if sound_node_group.has_node(sound_name):
			var sound_node = sound_node_group.get_node(sound_name)
			if sound_node.is_playing():
				return true
		return false
