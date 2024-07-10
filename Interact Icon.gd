extends Node2D
@onready var interact_icon = $"."
@onready var sprite_2d = $Sprite2D
@onready var player = self.get_tree().get_root().get_node("Game").get_node("World").get_node("Player")
@onready var area_2d = $Area2D
@onready var collision_shape_2d = $Area2D/CollisionShape2D

var icon_active = false
var player_interactable = false



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#if Engine.time_scale == 1:




func _on_area_2d_area_entered(area):
	if area is HitboxComponent:
		if area.get_parent().type == "Player":
			self.set_visible(true)
			player_interactable = true


func _on_area_2d_area_exited(area):
	if area is HitboxComponent:
		if area.get_parent().type == "Player":
			self.set_visible(false)
			player_interactable = false
