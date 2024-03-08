extends Control
class_name HealthDisplay

@onready var hurtOverlay: TextureRect = $HurtOverlay
@onready var orbCountLabel: Label = $OrbCountLabel
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

const HURT_DISPLAY_TIME: float = 1.5
const ORB_COUNT_FADE_TIME: float = 2

func _ready() -> void:
	animationPlayer.play("RESET")

func on_player_hurt() -> void:
	animationPlayer.play("hurt_animation")

func on_orbs_collected() -> void:
	animationPlayer.play("all_orbs_collected")

func update_orb_count(collectedCount: int, totalCount: int) -> void:
	orbCountLabel.text = "Collected: " + str(collectedCount) + "/" + str(totalCount)
