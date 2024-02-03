extends Control

@onready var player: Player = $".."
@onready var collectOrbsButton = $VBoxContainer/CollectAllOrbs
@onready var levelWarpMenu = $VBoxContainer/LevelWarpMenu

func _ready() -> void:
	var warpMenuPopup: PopupMenu = levelWarpMenu.get_popup()
	warpMenuPopup.index_pressed.connect(_on_level_select_button_pressed)
	for i in range(LevelManager.levels.size()):
		warpMenuPopup.add_item(
			"No Name" if i >= LevelManager.LEVEL_NAMES.size()
			else LevelManager.LEVEL_NAMES[i]
		)

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
	
func _on_level_select_button_pressed(index: int) -> void:
	LevelManager.currentLevel = index
	get_tree().change_scene_to_packed(LevelManager.levelLoader)
