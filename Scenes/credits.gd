extends Node2D

var mainMenuScene = "res://Scenes/main_menu.tscn"

func _on_btn_back_pressed():
	get_tree().change_scene_to_file(mainMenuScene)
