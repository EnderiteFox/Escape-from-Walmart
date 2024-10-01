extends Node3D

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var credits: VBoxContainer = $Credits
@onready var laitier: TextureRect = $Credits/Laitier
@onready var shade: ColorRect = $Shade
@onready var SHADE_LENGTH: int = (int) (DisplayServer.screen_get_size().y / 2.0)

const SCROLL_SPEED: float = 100
const FAST_SCROLL_MULTIPLIER: float = 5
const END_MARGIN: int = 50

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	animationPlayer.get_animation("walking_roomba") \
		.loop_mode = Animation.LOOP_LINEAR
	animationPlayer.play("walking_roomba")
	credits.position.y = DisplayServer.screen_get_size().y

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Back"):
		get_tree().change_scene_to_packed(LevelManager.mainMenu)
	credits.position.y -= SCROLL_SPEED * delta \
		* (FAST_SCROLL_MULTIPLIER if Input.is_action_pressed("CreditFastScroll")
			else 1.0)
	var last_node: Control = credits.get_children()[-1]
	if (last_node.global_position.y + last_node.size.y + END_MARGIN < 0):
		get_tree().change_scene_to_packed(LevelManager.mainMenu)
	
	var pos = clamp(get_laitier_position(), 0, SHADE_LENGTH)
	shade.color.a = 1 - (pos / SHADE_LENGTH)

func get_laitier_position() -> float:
	if not laitier.is_inside_tree(): return 0
	return laitier.get_screen_position().y + laitier.texture.get_size().y
	
func on_music_end() -> void:
	get_tree().change_scene_to_packed(LevelManager.mainMenu)
