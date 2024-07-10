extends Node2D
@onready var floor = $floor
@onready var shadow = $shadow
@onready var objects = $objects
@onready var objects_lower = $objects_lower
@onready var mobs = get_parent().get_node("Mobs")
@onready var player = get_parent().get_node("Player")
@onready var boss_arena = $boss_arena

var rand1
var rand2

var frameCount = 0
var tile_pos
var cell = Vector2i()
var tile_size = Vector2(16,16)
var bound_buffer = 450 
var tile_gen_count = 0
var pattern_index := 0

var arena_min_dist = 500
var arena_max_dist = 1000

#var pattern = floor.tile_set.get_pattern(3)
#
# 0 - 2 trees
# 3 - 8 bushes
#

# x / y coord buffer around player
# about 450 hides the generation from the defualt viewport
# this will need to be tweaked on the fly based on the resulution chosen

func _ready():
	pass
	

func _process(_delta):
	frameCount += 1
	
	if (frameCount % 15 == 0): # once every second at 60fps
		frameCount = 0
		gen_terrain()


func gen_terrain():
	var TL_bound = player.position + Vector2((-1 * bound_buffer),bound_buffer)
	var TR_bound = player.position + Vector2(bound_buffer,bound_buffer)
	var BL_bound = player.position + Vector2((-1 * bound_buffer),(-1 * bound_buffer))
	var _BR_bound = player.position + Vector2(bound_buffer,(-1 * bound_buffer))
	
	for x in range((TL_bound.x / tile_size.x), (TR_bound.x / tile_size.x)):
		for y in range((BL_bound.y / tile_size.y), (TL_bound.y / tile_size.y)):
			rand1 = randi() % 15
			rand2 = randi() % 7
			tile_pos = Vector2(x, y)
			cell = floor.get_cell_tile_data(0, tile_pos)
			if cell == null:
				if tile_gen_count == 200:
					gen_object(tile_pos, "small")
				if tile_gen_count == 400:
					gen_object(tile_pos, "medium")
				else:
					floor.set_cell(0, tile_pos, 1, Vector2(rand1, rand2))
					tile_gen_count += 1

func gen_object(tile_pos, type):
	tile_pos = Vector2i(tile_pos.x, tile_pos.y)
	var rand
	
	if type == "small":
		rand = randi_range(3, 8)
	if type == "medium":
		rand = randi_range(0, 3)
		tile_gen_count = 0
	
	if objects.tile_set.get_pattern(rand) != null: # pattern index exists
		var pattern_cells_a = objects.tile_set.get_pattern(rand).get_used_cells()
		var pattern_cells_b = shadow.tile_set.get_pattern(rand).get_used_cells()
		
		# Check if the pattern can be placed without overlapping existing objects
		var can_place_pattern = true
		
		for pattern_cell in pattern_cells_a:
			var test_cell_coords = tile_pos + pattern_cell
			var test_cell_a = objects.get_cell_tile_data(0, test_cell_coords)
			var test_cell_c = objects_lower.get_cell_tile_data(0, test_cell_coords)
			if test_cell_a != null || test_cell_c != null:  # Existing object found
				can_place_pattern = false
				break
		
		for pattern_cell in pattern_cells_b:
			var test_cell_coords = tile_pos + pattern_cell
			var test_cell_b = shadow.get_cell_tile_data(0, test_cell_coords)
			var test_cell_c = objects_lower.get_cell_tile_data(0, test_cell_coords)
			if test_cell_b != null || test_cell_c != null:  # Existing object found
					can_place_pattern = false
					break
		
		# If there are no overlaps, place the pattern
		if can_place_pattern:
			shadow.set_pattern(0, tile_pos, shadow.tile_set.get_pattern(rand))
			objects.set_pattern(0, tile_pos, objects.tile_set.get_pattern(rand))

func spawn_boss_arena():
	#print("Spawning arena...")
	var tile_pos
	var tile_size = 16
	var location_found = false
	
	# Check if the pattern exists
	if objects_lower.tile_set.get_pattern(9) != null and objects.tile_set.get_pattern(10) != null:
		#print("Pattern found")
		var lower_pattern_size = objects_lower.tile_set.get_pattern(9).get_size()
		var upper_pattern_size = objects.tile_set.get_pattern(10).get_size()
		var pattern_cells = floor.tile_set.get_pattern(2).get_used_cells()
		
		var lower_offset = Vector2i(lower_pattern_size.x / 2, lower_pattern_size.y / 2)
		var upper_offset = Vector2i(upper_pattern_size.x / 2, upper_pattern_size.y / 2)
		
		var player_pos = player.get_global_position()
		var mod
		var mod2
		var new_pos_x
		var new_pos_y
		var tilemap_pos
		var lower_tile_pos
		var upper_tile_pos
		var temp_pos
		var conflict
		
		while not location_found:
			conflict = false
			#print("Checking location...")
			mod = randi_range(0, 1)
			mod2 = randi_range(0, 1)
			if mod == 0: mod = -1
			if mod2 == 0: mod2 = -1
			
			new_pos_x = randi_range(player_pos.x + arena_min_dist, player_pos.x + arena_max_dist) * mod
			new_pos_y = randi_range(player_pos.y + arena_min_dist, player_pos.y + arena_max_dist) * mod2
			tile_pos = Vector2(new_pos_x, new_pos_y)
			tilemap_pos = Vector2i(tile_pos.x / tile_size, tile_pos.y / tile_size)
			lower_tile_pos = tilemap_pos - lower_offset
			upper_tile_pos = tilemap_pos - upper_offset
			
			# Check for conflicts with existing tiles in the pattern
			for pattern_cell in pattern_cells:
				var test_cell_coords = lower_tile_pos + pattern_cell
				var test_cell_floor = floor.get_cell_tile_data(0, test_cell_coords)
				var test_cell_shadow = shadow.get_cell_tile_data(0, test_cell_coords)
				var test_cell_objects_lower = objects_lower.get_cell_tile_data(0, test_cell_coords)
				var test_cell_objects = objects.get_cell_tile_data(0, test_cell_coords)
				
				if test_cell_floor != null or test_cell_shadow != null or test_cell_objects_lower != null or test_cell_objects != null:
					conflict = true
					break
			
			if conflict:
				#print("Conflict found, increasing search distance.")
				arena_min_dist += 250
				arena_max_dist += 250
			else:
				location_found = true
		
		#print("Setting patterns at:", lower_tile_pos, upper_tile_pos)
		boss_arena.init(tile_pos)
		floor.set_pattern(0, lower_tile_pos, floor.tile_set.get_pattern(2))
		shadow.set_pattern(0, lower_tile_pos, shadow.tile_set.get_pattern(9))
		objects_lower.set_pattern(0, lower_tile_pos, objects_lower.tile_set.get_pattern(9))
		objects.set_pattern(0, upper_tile_pos, objects.tile_set.get_pattern(10))
		player.arrow_pointer.init_pointer()
	else:
		print("Pattern not found")


