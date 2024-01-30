extends Control

@onready var player: Player = $".."
@onready var collectOrbsButton = $VBoxContainer/CollectAllOrbs

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("DebugMode"):
		self.visible = not self.visible
		Input.set_mouse_mode(
			Input.MOUSE_MODE_VISIBLE if self.visible
			else Input.MOUSE_MODE_CAPTURED
		)

func _on_invincibility_button_toggled(toggled_on: bool) -> void:
	LevelManager.invincibility = toggled_on


func _on_light_button_toggled(toggled_on: bool) -> void:
	LevelManager.debugLight = toggled_on


func _on_collect_all_orbs_pressed() -> void:
	player.map.all_orbs_collected.emit()
	collectOrbsButton.disabled = true
	
