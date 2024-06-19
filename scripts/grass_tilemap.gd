extends TileMap

var rand1
var rand2
@onready var player = get_parent().get_node("Player")
var frameCount = 0
var tile_pos
var cell = Vector2i()
var tile_size = Vector2(16,16)
var bound_buffer = 450 
# x / y coord buffer around player
# about 450 hides the generation from the defualt viewport
# this will need to be tweaked on the fly based on the resulution chosen

func _ready():
	pass

func _process(_delta):
	frameCount += 1

	if (frameCount % 15 == 0): # once every second at 60fps
		#print(player.position)
		var TL_bound = player.position + Vector2((-1 * bound_buffer),bound_buffer)
		var TR_bound = player.position + Vector2(bound_buffer,bound_buffer)
		var BL_bound = player.position + Vector2((-1 * bound_buffer),(-1 * bound_buffer))
		var _BR_bound = player.position + Vector2(bound_buffer,(-1 * bound_buffer))
		frameCount = 0
		
		for x in range((TL_bound.x / tile_size.x), (TR_bound.x / tile_size.x)):
			for y in range((BL_bound.y / tile_size.y), (TL_bound.y / tile_size.y)):
				rand1 = randi() % 15
				rand2 = randi() % 7
				tile_pos = Vector2(x, y)
				cell = get_cell_tile_data(0, tile_pos)
				if cell == null:
					set_cell(0, tile_pos, 1, Vector2(rand1, rand2))
