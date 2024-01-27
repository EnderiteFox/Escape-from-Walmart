extends Node3D
class_name Map


@export_range(0, 100, 1, "or_greater") var map_x_width: int
@export_range(0, 100, 1, "or_greater") var map_z_width: int
@export var ENEMIES: Array[PackedScene]


var PLAYER_SPAWN: Vector3
var ENEMIES_SPAWN: PackedVector3Array
var END_TRIGGER_SPAWN: Vector3


func _ready() -> void:
	PLAYER_SPAWN = $Spawns/PLAYER.global_position
	END_TRIGGER_SPAWN = $Spawns/END_TRIGGER.global_position
	var ENEMY_SPAWNS: Node3D = $Spawns/ENEMY_SPAWNS
	for spawn in ENEMY_SPAWNS.get_children():
		if not spawn is Node3D:
			continue
		ENEMIES_SPAWN.append(spawn.global_position)
