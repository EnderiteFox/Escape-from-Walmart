extends Node3D
class_name Level

@onready var exitDoor: ExitDoor = $ExitDoor
@onready var player: Player
@onready var NavRegion: NavigationRegion3D = $NavigationRegion3D
@onready var Map: Map = $NavigationRegion3D/Map

var allOrbs: bool = false

func _ready() -> void:
	player = preload("res://scene/Player.tscn").instantiate()
	add_child(player)
	player.global_position = Map.PLAYER_SPAWN
	for i in range(Map.ENEMIES.size()):
		var enemy: Enemy = Map.ENEMIES[i].instantiate()
		$EnemyContainer.add_child(enemy)
		enemy.global_position = Map.ENEMIES_SPAWN[i]
	NavRegion.bake_navigation_mesh()
	Map.all_orbs_collected.connect(on_all_orbs_collected)
	exitDoor.change_door_mesh(Map.EXIT_DOOR_MESH)
	exitDoor.global_position = Map.END_DOOR_SPAWN
	exitDoor.global_rotation = Map.END_DOOR_ROTATION

func _process(delta: float) -> void:
	player.healthDisplay.update_orb_count(Map.collected_orbs, Map.TOTAL_ORBS)

func on_enemy_hit_player(enemy: Enemy) -> void:
	player.damage(enemy.DAMAGE)
	if player.health <= 0:
		_on_death()

func _on_death() -> void:
	print("You're dead")
	
func on_all_orbs_collected() -> void:
	player.healthDisplay.on_orbs_collected()
	exitDoor.open()
