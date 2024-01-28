extends Control


@onready var level = preload("res://scene/level_template.tscn")
@onready var credits = preload("res://scene/CREDITS/Credits.tscn")

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Back"):
		get_tree().quit()

func _on_play_pressed():
	get_tree().change_scene_to_packed(level)
	
func _on_credits_pressed():
	get_tree().change_scene_to_packed(credits)

func _on_quit_pressed():
	get_tree().quit()
