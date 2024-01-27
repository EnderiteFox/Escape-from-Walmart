extends Node3D
class_name Level

@onready var EndTrigger: Area3D = $EndTrigger
@onready var player: Player
@onready var NavRegion: NavigationRegion3D = $NavigationRegion3D
@onready var Map: Map = $NavigationRegion3D/Map

func _ready() -> void:
	player = preload("res://scene/Player.tscn").instantiate()
	add_child(player)
	player.global_position = Map.PLAYER_SPAWN
	for i in range(Map.ENEMIES.size()):
		var enemy: Enemy = Map.ENEMIES[i].instantiate()
		$EnemyContainer.add_child(enemy)
		enemy.global_position = Map.ENEMIES_SPAWN[i]
	NavRegion.bake_navigation_mesh()

func _process(delta: float) -> void:
	pass

func _on_end_trigger_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D and body.name == "Player":
		end_level()

func on_enemy_hit_player(enemy: Enemy) -> void:
	player.damage(enemy.DAMAGE)
	if player.health <= 0:
		_on_death()

func _on_death() -> void:
	print("You're dead")
	
func end_level() -> void:
	print("Bye")
