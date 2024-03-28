extends Node3D
class_name PickupOrb

signal orb_pickup(orb: PickupOrb)

@export var pickupSounds: Array[AudioStream]

@onready var HitBox: Area3D = $Area3D
@onready var pickupSoundPlayer: AudioStreamPlayer3D = $PickupSoundPlayer

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		pickupSoundPlayer.stream = pickupSounds.pick_random()
		pickupSoundPlayer.play()
		orb_pickup.emit(self)
