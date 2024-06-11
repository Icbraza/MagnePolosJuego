extends Area2D

@export var target_level : PackedScene
var play1 = false
var play2 = false
@onready var colli2D = $"."

func _physics_process(delta):
	for body in colli2D.get_overlapping_bodies():
		if(body.name!="TileMap"):
			if(body.name=="Player1"):
				play1=true
			if(body.name=="Player2"):
				play2=true
	if(play1 and play2):
		get_tree().change_scene_to_packed(target_level)
