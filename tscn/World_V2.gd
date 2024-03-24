extends Node2D

@onready var hud = get_node("Control")
@onready var timer = $Timer

var runTimer := 0:
	set(value):
		runTimer = value
		hud.runTimer = runTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start(1) 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_timer_timeout():
	runTimer += 1
	timer.start(1) 
