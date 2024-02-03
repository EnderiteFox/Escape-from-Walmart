extends Node

@onready var levelLoader: PackedScene = preload("res://scene/level_template.tscn")
@onready var mainMenu: PackedScene = preload("res://scene/Menu.tscn")
@onready var credits: PackedScene = preload("res://scene/CREDITS/Credits.tscn")
@onready var deathScreen: PackedScene = preload("res://scene/death_screen.tscn")
@onready var levels: Array[PackedScene] = [
	preload("res://level/1_Basement.tscn"),
	preload("res://level/2_Food-Shop.tscn"),
	preload("res://level/3_Decathlon.tscn"),
	preload("res://level/4_Toy-Shop.tscn")
]

const LIVES_DEFAULT_AMOUNT: int = 2
const LEVEL_NAMES: Array[String] = [
	"Basement",
	"Food Shop",
	"Sport Shop",
	"Toy Shop"
]

var currentLevel: int = 0
var livesCount: int = LIVES_DEFAULT_AMOUNT
var invincibility: bool = false
var debugLight: bool = false
var fullscreen: bool = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Fullscreen"):
		fullscreen = not fullscreen
		DisplayServer.window_set_mode(
			DisplayServer.WINDOW_MODE_FULLSCREEN if fullscreen
			else DisplayServer.WINDOW_MODE_MAXIMIZED
		)

func get_current_level() -> PackedScene:
	return levels[currentLevel]

func on_level_finish() -> void:
	currentLevel += 1
	if currentLevel == levels.size():
		currentLevel = 0
		livesCount = LIVES_DEFAULT_AMOUNT
		get_tree().change_scene_to_packed(credits)
	else:
		get_tree().change_scene_to_packed(levelLoader)

func on_death() -> void:
	get_tree().change_scene_to_packed(deathScreen)

func on_retry() -> void:
	if livesCount == 0:
		livesCount = LIVES_DEFAULT_AMOUNT
		currentLevel = 0
	get_tree().change_scene_to_packed(levelLoader)
