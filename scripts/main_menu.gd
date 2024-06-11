extends Node

func _on_level_1_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")
	
func _on_level_2_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/level_2.tscn")
