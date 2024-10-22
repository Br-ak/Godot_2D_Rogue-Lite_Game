extends Area2D

var game
var world
var scenery
@onready var boss_arena_location

var pointer_active = false


# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_visible(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.time_scale == 1:
		if pointer_active:
			if boss_arena_location.distance_to(self.global_position) < 500:
				self.set_visible(false)
			elif boss_arena_location.distance_to(self.global_position) >= 500:
				self.set_visible(true)
				look_at(boss_arena_location)
		else:
			self.set_visible(false)

func init_pointer():
	for node in self.get_tree().get_root().get_children():
		if node.name == "Hub World": world = node
		elif node.name == "Game": 
			game = node
			world = game.get_node("World")
	scenery = world.get_node("scenery")
	pointer_active = true
	boss_arena_location = scenery.boss_arena.boss_arena_location.global_position
	if boss_arena_location != null:
		self.set_visible(true)
		look_at(boss_arena_location)
	else:
		self.set_visible(false)

