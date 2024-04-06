extends Node

@onready var mainMenu: PackedScene = preload("res://scene/Menu.tscn")
@onready var credits: PackedScene = preload("res://scene/credits/Credits.tscn")
@onready var deathScreen: PackedScene = preload("res://scene/death_screen.tscn")
@onready var levels: Array[PackedScene] = [
	load("res://level/1_Basement.tscn"),
	load("res://level/2-Food-Shop.tscn"),
	load("res://level/3-Decathlon.tscn"),
	load("res://level/4_Toy-Shop.tscn"),
	load("res://level/5_Cloth-Shop.tscn")
]

const LIVES_DEFAULT_AMOUNT: int = 2
const LEVEL_NAMES: Array[String] = [
	"Basement",
	"Food Shop",
	"Sport Shop",
	"Toy Shop",
	"Cloth Shop"
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
		get_tree().change_scene_to_packed(get_current_level())

func on_death() -> void:
	get_tree().change_scene_to_packed(deathScreen)

func on_retry() -> void:
	if livesCount == 0:
		livesCount = LIVES_DEFAULT_AMOUNT
		currentLevel = 0
	get_tree().change_scene_to_packed(get_current_level())
