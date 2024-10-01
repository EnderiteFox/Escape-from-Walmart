extends Control

@onready var debugMenu: Control = $"../DebugMenu"
@onready var volumeSlider: HSlider = $VBoxContainer/SliderMargin/VBoxContainer/HSlider

func _ready() -> void:
	volumeSlider.value = LevelManager.volume_multiplier * 100
	volumeSlider.value_changed.connect(LevelManager.on_volume_changed)
	

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		self.visible = not self.visible
		if self.visible:
			debugMenu.visible = false
		get_tree().paused = self.visible
		Input.set_mouse_mode(
			Input.MOUSE_MODE_VISIBLE if self.visible
			else Input.MOUSE_MODE_CAPTURED
		)

func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	self.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(LevelManager.mainMenu)
