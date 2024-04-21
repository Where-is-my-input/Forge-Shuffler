extends Control

var gameScene = "res://Scenes/main.tscn"
var creditsScene = "res://Scenes/credits.tscn"

func _on_credits_pressed():
	LoadCreditsScene()

func LoadGameScene():
	get_tree().change_scene_to_file(gameScene)

func LoadCreditsScene():
	get_tree().change_scene_to_file(creditsScene)

func _on_btn_play_pressed():
	LoadGameScene()

func _on_btn_credits_pressed():
	LoadCreditsScene()
