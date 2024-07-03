extends Node2D
@onready var floor = $floor
@onready var shadow = $shadow
@onready var objects = $objects
@onready var player = get_parent().get_node("Player")

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
			if test_cell_a != null && test_cell_a.custom_data_1 == true:  # Existing object found
				can_place_pattern = false
				break
		
		for pattern_cell in pattern_cells_b:
			var test_cell_coords = tile_pos + pattern_cell
			var test_cell_b = shadow.get_cell_tile_data(0, test_cell_coords)
			if test_cell_b != null:  # Existing object found
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
	
