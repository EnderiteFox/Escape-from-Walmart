extends Node

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var music_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var levelTitle: Label = $CanvasLayer/NextLevelAnimation/LevelTitle

@onready var sprites: Array[Sprite2D] = [
	$EscalatorAnimation/Sign/Sprite2D,
	$EscalatorAnimation/Sign2/Sprite2D
]

func _ready() -> void:
	levelTitle.text = LevelManager.LEVEL_NAMES[LevelManager.currentLevel]
	animation.play("escalator_up")
	for i in range(2):
		sprites[i].texture = LevelManager.levelImages[LevelManager.currentLevel - 1][i]
		sprites[i].position = Vector2(
			LevelManager.levelImageSize[LevelManager.currentLevel - 1][i][0],
			LevelManager.levelImageSize[LevelManager.currentLevel - 1][i][1]
		)
		sprites[i].scale = Vector2(
			LevelManager.levelImageSize[LevelManager.currentLevel - 1][i][2],
			LevelManager.levelImageSize[LevelManager.currentLevel - 1][i][3]
		)
	
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
