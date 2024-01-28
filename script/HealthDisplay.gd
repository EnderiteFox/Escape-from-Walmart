extends Control
class_name HealthDisplay

@onready var hurtOverlay: TextureRect = $HurtOverlay

const HURT_DISPLAY_TIME: float = 1.5
const ORB_COUNT_FADE_TIME: float = 2

var hurtTimeLeft: float = -1
var timeSinceComplete: float = -1

func _process(delta: float) -> void:
	$DebugModeDisplay.visible = LevelManager.debugMode
	if hurtTimeLeft >= 0.0:
		hurtOverlay.self_modulate.a = lerp(1.0, 0.0, \
			(HURT_DISPLAY_TIME - hurtTimeLeft) / HURT_DISPLAY_TIME)
		hurtTimeLeft -= delta
	else:
		hurtOverlay.self_modulate.a = 0
	if timeSinceComplete >= 0:
		$OrbCountLabel.label_settings.font_color = Color.GREEN
		timeSinceComplete += delta
		$OrbCountLabel.label_settings.font_color.a = lerp(0.0, 1.0, (ORB_COUNT_FADE_TIME - timeSinceComplete) / ORB_COUNT_FADE_TIME)

func on_player_hurt() -> void:
	hurtTimeLeft = HURT_DISPLAY_TIME

func on_orbs_collected() -> void:
	timeSinceComplete = 0

func update_orb_count(collectedCount: int, totalCount: int) -> void:
	$OrbCountLabel.text = "Collected: " + str(collectedCount) + "/" + str(totalCount)
