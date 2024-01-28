extends AudioStreamPlayer
class_name VoicelinePlayer

var alreadyPlayed := Dictionary()
var sounds: Dictionary = {
	WAIT_SHORT = [preload("res://voicelines/Pack 1/Level0_00_A.ogg")],
	WAIT_LONG = [preload("res://voicelines/Pack 1/Level0_01_A.ogg")]
}

enum VOICELINE {
	WAIT_SHORT,
	WAIT_LONG
}

func _ready() -> void:
	for voiceline in VOICELINE:
		alreadyPlayed[voiceline] = false
