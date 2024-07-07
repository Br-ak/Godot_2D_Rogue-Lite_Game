extends Node2D
@onready var floor = $floor
@onready var shadow = $shadow
@onready var objects = $objects
@onready var objects_lower = $objects_lower
@onready var mobs = get_parent().get_node("Mobs")
@onready var player = get_parent().get_node("Player")
@onready var boss_arena_location = $boss_arena_location

var rand1
var rand2

var frameCount = 0
var tile_pos
var cell = Vector2i()
var tile_size = Vector2(16,16)
var bound_buffer = 450 
var tile_gen_count = 0
var pattern_index := 0

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
		# Get the size of the pattern
		var pattern_size = objects.tile_set.get_pattern(rand).get_size()
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
			


func check_for_passable():
	var cell = objects.get_cell_tile_data(0, player.position)
	var test_cell
	var test_cell_coords : Vector2
	var range = 3
	
	if cell != null && cell.custom_data_0 == true:
			for i in range(-range, range):
				for j in range(-range, range):
					test_cell_coords.x = player.position.x + i
					test_cell_coords.y = player.position.y + j
					test_cell = objects.get_cell_tile_data(0, test_cell_coords)
					if test_cell != null && test_cell.custom_data_0 == true:
						test_cell.set_modulate(Color(1,1,1,0.5))

func spawn_boss_arena():
	print("Spawning arena...")
	var tile_pos
	var tile_size = 16
	
	# Check if the patterns exist before setting them
	if objects_lower.tile_set.get_pattern(9) != null and objects.tile_set.get_pattern(10) != null:
		print("Pattern found")
		var lower_pattern_size = objects_lower.tile_set.get_pattern(9).get_size()
		var upper_pattern_size = objects.tile_set.get_pattern(10).get_size()
		var lower_offset = Vector2i(lower_pattern_size.x / 2, lower_pattern_size.y / 2)
		var upper_offset = Vector2i(upper_pattern_size.x / 2, upper_pattern_size.y / 2)
		
		var player_pos = player.get_global_position()
		var new_pos_x = randi_range(player_pos.x + 500, player_pos.x + 1500)
		var new_pos_y = randi_range(player_pos.y + 500, player_pos.y + 1500)
		tile_pos = Vector2(new_pos_x, new_pos_y)
		
		var tilemap_pos = Vector2i(tile_pos.x / tile_size, tile_pos.y / tile_size)
		var lower_tile_pos = tilemap_pos - lower_offset
		var upper_tile_pos = tilemap_pos - upper_offset
		boss_arena_location.global_position = tile_pos
		
		floor.set_pattern(0, lower_tile_pos, floor.tile_set.get_pattern(2))
		shadow.set_pattern(0, lower_tile_pos, shadow.tile_set.get_pattern(9))
		objects_lower.set_pattern(0, lower_tile_pos, objects_lower.tile_set.get_pattern(9))
		objects.set_pattern(0, upper_tile_pos, objects.tile_set.get_pattern(10))
		player.arrow_pointer.init_pointer()
	else:
		print("Pattern not found")
