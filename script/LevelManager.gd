extends Node

@onready var mainMenu: PackedScene = preload("res://scene/Menu.tscn")
@onready var credits: PackedScene = preload("res://scene/credits/Credits.tscn")
@onready var deathScreen: PackedScene = preload("res://scene/death_screen.tscn")
@onready var transition: PackedScene = preload("res://scene/level_transition/transition.tscn")
@onready var levels: Array[PackedScene] = [
	load("res://level/1_Basement.tscn"),
	load("res://level/2-Food-Shop.tscn"),
	load("res://level/3-Decathlon.tscn"),
	load("res://level/4_Toy-Shop.tscn"),
	load("res://level/5_Cloth-Shop.tscn")
]
@onready var levelImages: Array[Array] = [
	[
		ResourceLoader.load("res://image/transition_images/level_2/donkey.png"),
		ResourceLoader.load("res://image/transition_images/level_2/shrek.png")
	],
	[
		ResourceLoader.load("res://image/transition_images/level_3/mannequin.png"),
		ResourceLoader.load("res://image/transition_images/level_3/mannequin2.png")
	],
	[
		ResourceLoader.load("res://image/transition_images/level_4/cubes.png"),
		ResourceLoader.load("res://image/transition_images/level_4/thomas.png")
	],
	[
		ResourceLoader.load("res://image/transition_images/level_5/crying_angel.png"),
		ResourceLoader.load("res://image/transition_images/level_5/think.png")
	]
]

@onready var levelImageSize: Array[Array] = [
	[
		[-1.019, -2.386, 0.084, 0.046],
		[-0.653, -2.365, 0.045, 0.036]
	],
	[
		[-0.994, -2.56, 0.021, 0.01],
		[-0.706, -2.496, 0.03, 0.021]
	],
	[
		[-1.019, -2.485, 0.085, 0.048],
		[-1.04, -2.496, 0.059, 0.033]
	],
	[
		[-1.019, -2.485, 0.066, 0.066],
		[-0.983, -2.483, 0.018, 0.01]
	]
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
var volume_multiplier: float = 1.0

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
		get_tree().change_scene_to_packed(transition)

func on_death() -> void:
	get_tree().change_scene_to_packed(deathScreen)

func on_retry() -> void:
	if livesCount == 0:
		livesCount = LIVES_DEFAULT_AMOUNT
		currentLevel = 0
	get_tree().change_scene_to_packed(get_current_level())
	
func on_volume_changed(value: float) -> void:
	volume_multiplier = value / 100;
	var node: Node = get_tree().current_scene
	if node != null:
		if node is Level:
			node.change_music_volume(volume_multiplier)
		else:
			print("node is not Level")
	else:
		print("node is null")
	
