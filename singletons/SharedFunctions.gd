extends Node

@onready var upgrades = StaticData.upgrades["upgrades"]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_attack_info(WEAPON_NAME):
	var weapon_data = StaticData.weapons["weapons"][WEAPON_NAME]["attacks"]
	
	var weapon_attack_count = 0
	var attack1 = Attack.new()
	var attack2 = Attack.new()
	
	for attack_info in weapon_data:
		if attack_info == "attack1":
			weapon_attack_count += 1
			for key in StaticData.weapon_stat_list:
				if weapon_data["attack1"].has(key): attack1.set(key, weapon_data["attack1"][key])
			attack1.WEAPON_NAME = WEAPON_NAME
			attack1.ATTACK_NUMBER = 1
		elif attack_info == "attack2":
			weapon_attack_count += 1
			for key in StaticData.weapon_stat_list:
				if weapon_data["attack2"].has(key): attack2.set(key, weapon_data["attack2"][key])
			attack2.WEAPON_NAME = WEAPON_NAME
			attack2.ATTACK_NUMBER = 2
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
	# handle attack patterns
	if attack.attack_pattern == "BASIC":
		basic_projectile(projectile_object, root, shooting_point, mouse_position, attack)
	elif attack.attack_pattern == "FORK":
		fork_projectile(projectile_object, root, shooting_point, mouse_position, attack)
	elif attack.attack_pattern == "SPREAD":
		spread_projectile(projectile_object, root, shooting_point, mouse_position, attack)

# handles basic/single projectile
func basic_projectile(projectile_object, root, shooting_point, mouse_position, attack):
	var new_projectile = projectile_object.instantiate()
	new_projectile.attack = attack
	new_projectile.global_position = shooting_point.global_position
	if attack.attack_type == "GUN":
		new_projectile.global_position = shooting_point.global_position
		new_projectile.global_rotation = shooting_point.global_rotation
	else:
		new_projectile.look_at(mouse_position)
	root.add_child(new_projectile)

func spread_projectile(projectile_object, root, shooting_point, mouse_position, attack):
	var spread_angle
	
	spread_angle = 45
	var projectile_count = attack.attack_projectile_count # The number of projectiles to spawn
	var angle_step = spread_angle / (projectile_count - 1) # Calculate the angle between each projectile
	
	for i in range(projectile_count):
		var new_projectile = projectile_object.instantiate()
		new_projectile.attack = attack
		new_projectile.global_position = shooting_point.global_position
		
		# Calculate the angle for the current projectile
		var angle_offset = -spread_angle / 2 + i * angle_step
		var direction = (mouse_position - shooting_point.global_position).normalized()
		var rotation = direction.angle() + deg_to_rad(angle_offset)
		
		new_projectile.rotation = rotation
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
				if attack.attack_type == "GUN":
					new_projectile.global_position = shooting_point.global_position
					new_projectile.global_rotation = shooting_point.global_rotation
				else:
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
				if attack.attack_type == "GUN":
					new_projectile.global_position = shooting_point.global_position
					new_projectile.global_rotation = shooting_point.global_rotation
				else:
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

func init_attacks(WEAPON_NAME):
	var primary_attack = Attack.new()
	var secondary_attack = Attack.new()
	if primary_attack:
		var base_weapon_info = get_attack_info(WEAPON_NAME)
		if base_weapon_info[0] is String: print("No attacks found")
		elif base_weapon_info.size() == 1 && base_weapon_info[0] is Attack: # 1 atttack found
			primary_attack = base_weapon_info[0]
			primary_attack.update_attack_damage()
			return [primary_attack]
		elif base_weapon_info.size() == 2 && base_weapon_info[1] is Attack: # 2 atttacks found
			primary_attack = base_weapon_info[0]
			secondary_attack = base_weapon_info[1]
			primary_attack.update_attack_damage()
			secondary_attack.update_attack_damage()
			return [primary_attack, secondary_attack]

func reset_attack(attack) -> Attack:
	var base_weapon_info = get_attack_info(attack.WEAPON_NAME)
	attack = base_weapon_info[attack.ATTACK_NUMBER - 1]
	attack.update_attack_damage() # might not be needed
	return attack

func update_attacks(upgrade_list, attack_to_update):
	attack_to_update = reset_attack(attack_to_update)
	for attack_modification in upgrade_list:
		if upgrades.has(attack_modification):
				for changes in upgrades[attack_modification]["stats"]:
					if upgrades[attack_modification]["stats"].has(changes): 
						attack_to_update.set(changes, upgrades[attack_modification]["stats"][changes])
				attack_to_update.update_attack_damage()
	return attack_to_update

func is_mouse_between_points(mouse_pos: Vector2, point_a: Vector2, point_b: Vector2) -> bool:
	var min_x = min(point_a.x, point_b.x)
	var max_x = max(point_a.x, point_b.x)
	var min_y = min(point_a.y, point_b.y)
	var max_y = max(point_a.y, point_b.y)
	
	return mouse_pos.x >= min_x and mouse_pos.x <= max_x and mouse_pos.y >= min_y and mouse_pos.y <= max_y
