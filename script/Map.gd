extends Node3D
class_name Map

@export_range(0, 100, 1, "or_greater") var map_x_width: int
@export_range(0, 100, 1, "or_greater") var map_z_width: int
@export var PLAYER_SPAWN: Vector3
@export var ENEMIES: Array[PackedScene]
@export var ENEMIES_SPAWN: PackedVector3Array
