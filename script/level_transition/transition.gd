extends Node

@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation.play("escalator_up")
