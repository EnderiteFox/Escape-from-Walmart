extends Control


@onready var level = preload("res://scene/level_template.tscn")

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_play_pressed():
	get_tree().change_scene_to_packed(level)
	
func _on_credits_pressed():
	get_tree().change_scene_to_file("res://scene/CREDITS/GodotCredits.tscn")

func _on_quit_pressed():
	get_tree().quit()
