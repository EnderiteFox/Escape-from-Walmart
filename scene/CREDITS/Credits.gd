extends Node3D

@onready var menu: PackedScene = preload("res://scene/Menu.tscn")
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var credits: VBoxContainer = $Credits

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
		get_tree().change_scene_to_packed(menu)
	credits.position.y -= SCROLL_SPEED * delta \
		* (FAST_SCROLL_MULTIPLIER if Input.is_action_pressed("CreditFastScroll")
			else 1.0)
	var last_node: Control = credits.get_children()[-1]
	if (last_node.global_position.y + last_node.size.y + END_MARGIN < 0):
		get_tree().change_scene_to_packed(menu)
