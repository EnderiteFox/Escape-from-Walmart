extends Control

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var bottomText: Label = $VBoxContainer/BottomTextLocation/BottomText

const firstDeathMessage: String = "Be careful now..."
const secondDeathMessage: String = "Back to the beginning"

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var deathCount: int = LevelManager.deathCount
	bottomText.text = firstDeathMessage if deathCount < 2 else secondDeathMessage
	animationPlayer.play("death_animation")


func _on_retry_button_pressed() -> void:
	LevelManager.on_retry()
