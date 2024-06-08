extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init_attacks(WEAPON_NAME):
	var weapon_data = StaticData.weapons["weapons"][WEAPON_NAME]["attacks"]
	
	var weapon_attack_count = 0
	var attack1 = Attack.new()
	var attack2 = Attack.new()
	
	for attack_info in weapon_data:
		if attack_info == "attack1":
			weapon_attack_count += 1
			for key in StaticData.weapon_stat_list:
				if weapon_data["attack1"].has(key): attack1.set(key, weapon_data["attack1"][key])
		elif attack_info == "attack2":
			weapon_attack_count += 1
			for key in StaticData.weapon_stat_list:
				if weapon_data["attack2"].has(key): attack2.set(key, weapon_data["attack2"][key])
		else:
			pass
	if weapon_attack_count == 0:
		return ["No attacks found"]
	elif weapon_attack_count == 1:
		return [attack1]
	elif weapon_attack_count == 2:
		return [attack1, attack2]

# handles/sorts all projectile types
func fire_projectile(projectile_object, root, shooting_point, mouse_position, attack):
	print(attack.attack_damage)
	print(attack.attack_base_damage)
	print(attack.attack_pattern)
	if attack.attack_pattern == "BASIC":
		basic_projectile(projectile_object, root, shooting_point, mouse_position, attack)
	elif attack.attack_pattern == "FORK":
		fork_projectile(projectile_object, root, shooting_point, mouse_position, attack)

# handles basic/single projectile
func basic_projectile(projectile_object, root, shooting_point, mouse_position, attack):
	var new_projectile = projectile_object.instantiate()
	new_projectile.attack = attack
	new_projectile.global_position = shooting_point.global_position
	new_projectile.look_at(mouse_position)
	root.add_child(new_projectile)

# handles projectile forking
func fork_projectile(projectile_object, root, shooting_point, mouse_position, attack):
	var prev_projectile_position : Vector2
	var prev_projectile_rotation : float
	var direction_vector : Vector2 #Vector2(0, -) upwards direction, Vector2(0, +) downwards direction
	var rotation_radians : float
	var above_direction_variable
	var below_direction_variable
	if attack.attack_projectile_count % 2 == 0: # even projectile count
		above_direction_variable = -0.5
		below_direction_variable = 0.5
		for i in range(1, attack.attack_projectile_count + 2):
			var new_projectile = projectile_object.instantiate()
			new_projectile.attack = attack
			if !prev_projectile_position:
				new_projectile.global_position = shooting_point.global_position
				new_projectile.look_at(mouse_position)
				prev_projectile_rotation = new_projectile.rotation_degrees
				prev_projectile_position = new_projectile.position
			elif prev_projectile_position:
				if i % 2 == 0:
					direction_vector = Vector2(0, above_direction_variable) # Upwards direction
					above_direction_variable -= 1
				else:
					direction_vector = Vector2(0, below_direction_variable) # Downwards direction
					below_direction_variable += 1
				rotation_radians = deg_to_rad(prev_projectile_rotation)
				direction_vector = direction_vector.rotated(rotation_radians)
				new_projectile.position = prev_projectile_position + direction_vector * attack.attack_projectile_offset
				new_projectile.rotation_degrees = prev_projectile_rotation
				get_tree().root.add_child(new_projectile)
	else: # odd projectile count
		above_direction_variable = -1
		below_direction_variable = 1
		for i in range(1, attack.attack_projectile_count + 1):
			var new_projectile = projectile_object.instantiate()
			new_projectile.attack = attack
			if !prev_projectile_position:
				new_projectile.global_position = shooting_point.global_position
				new_projectile.look_at(mouse_position)
				prev_projectile_rotation = new_projectile.rotation_degrees
				prev_projectile_position = new_projectile.position
			elif prev_projectile_position:
				if i % 2 == 0:
					direction_vector = Vector2(0, above_direction_variable) # Upwards direction
					above_direction_variable -= 1
				else:
					direction_vector = Vector2(0, below_direction_variable) # Downwards direction
					below_direction_variable += 1
				rotation_radians = deg_to_rad(prev_projectile_rotation)
				direction_vector = direction_vector.rotated(rotation_radians)
				new_projectile.position = prev_projectile_position + direction_vector * attack.attack_projectile_offset
				new_projectile.rotation_degrees = prev_projectile_rotation
			root.add_child(new_projectile)
