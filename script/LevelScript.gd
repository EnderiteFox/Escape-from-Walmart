extends Node3D
class_name Level

@export_range(0, 100, 1, "or_greater") var map_x_width: int
@export_range(0, 100, 1, "or_greater") var map_z_width: int
@export var AMBIENCE_MUSIC: AudioStream
@export var AMBIENCE_MUSIC_VOLUME: float = 1
@export var DAY_MUSIC: AudioStream
@export var DAY_MUSIC_VOLUME: float = 1

@onready var map: Node3D = $NavRegion/Map
@onready var exitDoor: ExitDoor = $ExitDoor
@onready var player: Player = $Player
@onready var NavRegion: NavigationRegion3D = $NavRegion
@onready var audioStreamPlayer: AudioStreamPlayer = $AudioStreamPlayer
@onready var roombaScene: PackedScene = preload("res://scene/enemies/roomba_evil.tscn")
@onready var lights: Node3D = $NavRegion/Map/Lights
@onready var worldEnvironment: WorldEnvironment = $WorldEnvironment

const ROOMBA_SPAWN_TIME: float = 1.0
const ENEMY_LIGHT_SPEED_BUFF: int = 3

var allOrbs: bool = false
var collectedOrbs: int = 0
var totalOrbs: int = 0
var timeSinceOpen: float = 0.0

func _ready() -> void:
	for enemy in $EnemyContainer.get_children():
		enemy.SPEED -= ENEMY_LIGHT_SPEED_BUFF
		enemy.SPEED = max(enemy.SPEED, 1)
	for node in getPickupOrbs():
		if not node is PickupOrb: continue
		var orb: PickupOrb = node as PickupOrb
		orb.orb_pickup.connect(_on_orb_pickup)
		totalOrbs += 1
	NavRegion.bake_navigation_mesh()
	audioStreamPlayer.stream = AMBIENCE_MUSIC
	change_music_volume(LevelManager.volume_multiplier)
	audioStreamPlayer.play()
	worldEnvironment.environment.volumetric_fog_enabled = true
	
func change_music_volume(volume: float) -> void:
	audioStreamPlayer.volume_db = linear_to_db(
		volume * (AMBIENCE_MUSIC_VOLUME if !allOrbs else DAY_MUSIC_VOLUME)
	)
	
func getPickupOrbs() -> Array[PickupOrb]:
	var orbs: Array[PickupOrb] = []
	for node in $NavRegion/Map/PickupOrbs.get_children():
		if not node is PickupOrb: continue
		orbs.append(node as PickupOrb)
	return orbs

func _process(delta: float) -> void:
	player.healthDisplay.update_orb_count(collectedOrbs, totalOrbs)
	if exitDoor.is_opened and timeSinceOpen >= 0.0:
		timeSinceOpen += delta
	if timeSinceOpen >= ROOMBA_SPAWN_TIME:
		timeSinceOpen = -1
		var roomba: Enemy = roombaScene.instantiate()
		$EnemyContainer.add_child(roomba)
		roomba.global_position = exitDoor.global_position
		

func on_enemy_hit_player(enemy: Enemy) -> void:
	player.damage(enemy.DAMAGE)

func _on_orb_pickup(orb: PickupOrb) -> void:
	collectedOrbs += 1
	var soundPlayer: AudioStreamPlayer3D = orb.pickupSoundPlayer
	var soundPosition: Vector3 = soundPlayer.global_position
	orb.remove_child(soundPlayer)
	map.add_child(soundPlayer)
	soundPlayer.global_position = soundPosition
	orb.queue_free()
	if collectedOrbs == totalOrbs:
		on_all_orbs_collected()
	
func on_all_orbs_collected() -> void:
	collectedOrbs = totalOrbs
	for orb in map.find_child("PickupOrbs").get_children():
		orb.queue_free()
	player.healthDisplay.on_orbs_collected()
	exitDoor.open()
	allOrbs = true
	if DAY_MUSIC != null:
		var play_time: float = audioStreamPlayer.get_playback_position()
		audioStreamPlayer.stop()
		audioStreamPlayer.stream = DAY_MUSIC
		change_music_volume(LevelManager.volume_multiplier)
		audioStreamPlayer.play()
		audioStreamPlayer.seek(play_time)
	lights.visible = true
	worldEnvironment.environment.volumetric_fog_enabled = false
	for enemy in $EnemyContainer.get_children():
		enemy.SPEED += ENEMY_LIGHT_SPEED_BUFF
		enemy.stun(0)
		enemy.ALL_SEEING = true
