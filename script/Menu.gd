extends Control

func _on_play_pressed():
	get_tree().change_scene_to_file("res://level/0_Basement.tscn")
	
func _on_credits_pressed():
	get_tree().change_scene_to_file("res://scene/CREDITS/GodotCredits.tscn")

func _on_quit_pressed():
	get_tree().quit()
