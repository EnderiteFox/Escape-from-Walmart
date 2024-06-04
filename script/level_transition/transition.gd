extends Node

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var music_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var levelTitle: Label = $CanvasLayer/NextLevelAnimation/LevelTitle

func _ready() -> void:
	levelTitle.text = LevelManager.LEVEL_NAMES[LevelManager.currentLevel]
	animation.play("escalator_up")
	
func _process(_delta: float) -> void:
	if Input.is_action_pressed("Confirm"):
		animation.speed_scale = 3
		music_player.pitch_scale = 1.5
	else:
		animation.speed_scale = 1
		music_player.pitch_scale = 1
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name != "escalator_up":
		return
	get_tree().change_scene_to_packed(LevelManager.get_current_level())
