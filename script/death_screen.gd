extends Control

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var bottomText: Label = $VBoxContainer/BottomTextLocation/BottomText
@onready var lifeDisplay: Label = $LifeDisplay

const firstDeathMessage: String = "Be careful now..."
const secondDeathMessage: String = "Back to the beginning"

func _ready() -> void:
	bottomText.text = firstDeathMessage if LevelManager.livesCount >= 2 \
		else secondDeathMessage
	lifeDisplay.text = "Lives left: " + str(LevelManager.livesCount)
	animationPlayer.play("life_fade_in")

func _on_retry_button_pressed() -> void:
	animationPlayer.play("RESET")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "RESET":
		LevelManager.on_retry()
	elif anim_name == "life_fade_in":
		LevelManager.livesCount -= 1
		lifeDisplay.text = "Lives left: " + str(LevelManager.livesCount)
		animationPlayer.play("life_deplete")
	elif anim_name == "life_deplete":
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		animationPlayer.play("death_animation")
