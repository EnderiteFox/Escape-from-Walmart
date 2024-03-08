extends Node3D
class_name Map

signal all_orbs_collected


func _ready() -> void:
	var ENEMY_SPAWNS: Node3D = $Spawns/ENEMY_SPAWNS
	for spawn in ENEMY_SPAWNS.get_children():
		if not spawn is Node3D:
			continue
		ENEMIES_SPAWN.append(spawn.global_position)
	TOTAL_ORBS = 0
	for node in $PickupOrbs.get_children():
		if not node is PickupOrb:
			continue
		var orb: PickupOrb = node as PickupOrb
		orb.orb_pickup.connect(_on_orb_pickup)
		TOTAL_ORBS += 1

func _on_orb_pickup(orb: PickupOrb) -> void:
	collected_orbs += 1
	orb.queue_free()
	if collected_orbs == TOTAL_ORBS:
		all_orbs_collected.emit()
