extends Node3D

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animationPlayer.get_animation("walking_roomba").loop_mode = Animation.LOOP_LINEAR
	animationPlayer.play("walking_roomba")
