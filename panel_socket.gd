extends PanelContainer
@onready var inventory_menu = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_mouse_entered():
	print("entered")


func _on_area_2d_mouse_exited():
	print("exited")
