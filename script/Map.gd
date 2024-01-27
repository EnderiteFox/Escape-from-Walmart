extends Node3D
class_name Map


@export_range(0, 100, 1, "or_greater") var map_x_width: int
@export_range(0, 100, 1, "or_greater") var map_z_width: int
@export var ENEMIES: Array[PackedScene]


var PLAYER_SPAWN: Vector3
var ENEMIES_SPAWN: PackedVector3Array
var END_TRIGGER_SPAWN: Vector3

var TOTAL_ORBS: int
var collected_orbs: int = 0


func _ready() -> void:
	PLAYER_SPAWN = $Spawns/PLAYER.global_position
	END_TRIGGER_SPAWN = $Spawns/END_TRIGGER.global_position
	var ENEMY_SPAWNS: Node3D = $Spawns/ENEMY_SPAWNS
	for spawn in ENEMY_SPAWNS.get_children():
		if not spawn is Node3D:
			continue
		ENEMIES_SPAWN.append(spawn.global_position)
	TOTAL_ORBS = 0
	for node in _get_all_orbs($PickupOrbs):
		if not node is PickupOrb:
			continue
		var orb: PickupOrb = node as PickupOrb
		orb.orb_pickup.connect(_on_orb_pickup)
		TOTAL_ORBS += 1

func _get_all_orbs(node: Node) -> Array[Node]:
	var array: Array[Node] = node.get_children()
	var iteratedArray: Array[Node] = Array(array)
	for orb in iteratedArray:
		if not orb is PickupOrb:
			array.erase(orb)
			array.append_array(_get_all_orbs(orb))
	return array

func _on_orb_pickup(orb: PickupOrb) -> void:
	collected_orbs += 1
	orb.queue_free()
