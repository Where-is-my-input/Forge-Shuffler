extends CanvasLayer

@onready var warning_label: Label = $"MarginContainer/VBContainer/Warning Label"

func _ready() -> void:
	warning_label.visible = false

func _on_resume_button_pressed() -> void:
	Engine.time_scale = 1
	visible = false

func _on_main_menu_button_pressed() -> void:
	LoadMainMenu()

func LoadMainMenu() -> void:
	get_tree().change_scene_to_packed(Global.MAIN_SCENE)


func _on_main_menu_button_mouse_entered() -> void:
	warning_label.visible = true

func _on_main_menu_button_mouse_exited() -> void:
	warning_label.visible = false
