extends Control

@onready var info = $CanvasLayer/info
var temp = info
@onready var killCounter = $CanvasLayer/kills:
	set(value):
		print(value)
		if killCounter == null: # for some reason this is null upon startup for a second
			pass
		else:
			killCounter.text = "Kills: " + str(value)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var fps = Engine.get_frames_per_second()
	info.text = "FPS: " + str(fps)
