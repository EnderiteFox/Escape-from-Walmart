extends Node3D
class_name PickupOrb

signal orb_pickup(orb: PickupOrb)

@onready var HitBox: Area3D = $Sphere/Area3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		orb_pickup.emit(self)
