extends Node3D
class_name Level

@onready var EndTrigger: Area3D = $EndTrigger

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_end_trigger_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D and body.name == "Player":
		end_level()

func _on_enemy_hit_player(enemy: Enemy) -> void:
	pass
	
func end_level() -> void:
	print("Hello")
