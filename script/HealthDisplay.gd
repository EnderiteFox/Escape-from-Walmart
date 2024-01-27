extends Control
class_name HealthDisplay

@onready var hurtOverlay: TextureRect = $HurtOverlay

const HURT_DISPLAY_TIME: float = 1.5

var hurtTimeLeft: float = -1

func _process(delta: float) -> void:
	if hurtTimeLeft >= 0.0:
		hurtOverlay.self_modulate.a = lerp(1.0, 0.0, \
			(HURT_DISPLAY_TIME - hurtTimeLeft) / HURT_DISPLAY_TIME)
		hurtTimeLeft -= delta
	else:
		hurtOverlay.self_modulate.a = 0

func on_player_hurt() -> void:
	hurtTimeLeft = HURT_DISPLAY_TIME

func update_orb_count(collectedCount: int, totalCount: int) -> void:
	$OrbCountLabel.text = "Collected: " + str(collectedCount) + "/" + str(totalCount)
