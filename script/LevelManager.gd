extends Node

@onready var levelLoader: PackedScene = preload("res://scene/level_template.tscn")
@onready var mainMenu: PackedScene = preload("res://scene/Menu.tscn")
@onready var credits: PackedScene = preload("res://scene/CREDITS/GodotCredits.tscn")
@onready var levels: Array[PackedScene] = [
	preload("res://level/0_Basement.tscn")
]

var currentLevel: int = 0

func get_current_level() -> PackedScene:
	return levels[currentLevel]

func on_level_finish() -> void:
	currentLevel += 1
	get_tree().change_scene_to_packed(
		credits if currentLevel == levels.size() else levelLoader
	)
