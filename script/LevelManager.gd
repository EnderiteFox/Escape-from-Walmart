extends Node

@onready var levelLoader: PackedScene = preload("res://scene/level_template.tscn")
@onready var mainMenu: PackedScene = preload("res://scene/Menu.tscn")
@onready var credits: PackedScene = preload("res://scene/CREDITS/Credits.tscn")
@onready var deathScreen: PackedScene = preload("res://scene/death_screen.tscn")
@onready var levels: Array[PackedScene] = [
	preload("res://level/0_Basement.tscn"),
	preload("res://level/1_Food-Shop.tscn"),
	preload("res://level/2_Decathlon.tscn")
]

var currentLevel: int = 0
var deathCount: int = 0
var debugMode: bool = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("DebugMode"):
		debugMode = not debugMode

func get_current_level() -> PackedScene:
	return levels[currentLevel]

func on_level_finish() -> void:
	currentLevel += 1
	if currentLevel == levels.size():
		currentLevel = 0
		get_tree().change_scene_to_packed(credits)
	else:
		get_tree().change_scene_to_packed(levelLoader)

func on_death() -> void:
	deathCount += 1
	get_tree().change_scene_to_packed(deathScreen)

func on_retry() -> void:
	if deathCount >= 2:
		deathCount = 0
		currentLevel = 0
	get_tree().change_scene_to_packed(levelLoader)
