extends Node3D
class_name Level

@onready var exitDoor: ExitDoor = $ExitDoor
@onready var player: Player
@onready var NavRegion: NavigationRegion3D = $NavigationRegion3D
@onready var audioStreamPlayer: AudioStreamPlayer = $AudioStreamPlayer
@onready var roombaScene: PackedScene = preload("res://scene/enemies/roomba_evil.tscn")

const ROOMBA_SPAWN_TIME: float = 1.0

var map: Map
var allOrbs: bool = false
var timeSinceOpen: float = 0.0

func _ready() -> void:
	map = LevelManager.get_current_level().instantiate()
	NavRegion.add_child(map)
	player = preload("res://scene/Player.tscn").instantiate()
	add_child(player)
	player.global_position = map.PLAYER_SPAWN
	for i in range(map.ENEMIES.size()):
		var enemy: Enemy = map.ENEMIES[i].instantiate()
		$EnemyContainer.add_child(enemy)
		enemy.global_position = map.ENEMIES_SPAWN[i]
	NavRegion.bake_navigation_mesh()
	map.all_orbs_collected.connect(on_all_orbs_collected)
	exitDoor.change_door_mesh(map.EXIT_DOOR_MESH)
	exitDoor.global_position = map.END_DOOR_SPAWN
	exitDoor.global_rotation = map.END_DOOR_ROTATION
	audioStreamPlayer.stream = map.AMBIENCE_MUSIC
	audioStreamPlayer.volume_db = map.AMBIENCE_MUSIC_VOLUME
	audioStreamPlayer.play()

func _process(delta: float) -> void:
	player.healthDisplay.update_orb_count(map.collected_orbs, map.TOTAL_ORBS)
	if exitDoor.is_opened and timeSinceOpen >= 0.0:
		timeSinceOpen += delta
	if timeSinceOpen >= ROOMBA_SPAWN_TIME:
		timeSinceOpen = -1
		var roomba: Enemy = roombaScene.instantiate()
		$EnemyContainer.add_child(roomba)
		roomba.global_position = exitDoor.global_position
		

func on_enemy_hit_player(enemy: Enemy) -> void:
	player.damage(enemy.DAMAGE)
	if player.health <= 0:
		_on_death()

func _on_death() -> void:
	print("You're dead")
	
func on_all_orbs_collected() -> void:
	player.healthDisplay.on_orbs_collected()
	exitDoor.open()
	if map.DAY_MUSIC != null:
		audioStreamPlayer.stop()
		audioStreamPlayer.stream = map.DAY_MUSIC
		audioStreamPlayer.volume_db = map.DAY_MUSIC_VOLUME
		audioStreamPlayer.play()
