extends Node3D
class_name ExitDoor

@export var DoorMesh: PackedScene

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

var is_opened: bool = false
var is_player_in_area = false

func _ready() -> void:
	var leftDoor: Node3D = DoorMesh.instantiate()
	leftDoor.rotation.y = -90
	$LeftMeshPivot.add_child(leftDoor)
	leftDoor.position.x = 1
	
	var rightDoor: Node3D = DoorMesh.instantiate()
	rightDoor.rotation.y = 90
	$RightMeshPivot.add_child(rightDoor)
	rightDoor.position.x = -1

func _process(delta: float) -> void:
	if is_opened and is_player_in_area:
		on_player_exit()
		
func on_player_exit() -> void:
	pass

func open() -> void:
	is_opened = true
	animationPlayer.play("open")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		is_player_in_area = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is Player:
		is_player_in_area = false
