extends Node3D
class_name ExitDoor

@export var DoorMesh: PackedScene

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

var is_opened: bool = false
var is_player_in_area = false

func _ready() -> void:
	change_door_mesh(preload("res://mesh/exit_doors/wooden_door/wooden_door.tscn"))

func change_door_mesh(doorMesh: PackedScene) -> void:
	if doorMesh == null:
		print("ERROR: No exit door mesh found")
		return
	animationPlayer.play("RESET")
	var leftDoor: Node3D = doorMesh.instantiate()
	$LeftMeshPivot.add_child(leftDoor)
	leftDoor.position.x = 1
	leftDoor.rotation.y = -PI/2
	
	var rightDoor: Node3D = doorMesh.instantiate()
	$RightMeshPivot.add_child(rightDoor)
	rightDoor.position.x = -1
	rightDoor.rotation.y = PI/2

func _process(_delta: float) -> void:
	if is_opened and is_player_in_area:
		on_player_exit()
		
func on_player_exit() -> void:
	LevelManager.on_level_finish()

func open() -> void:
	is_opened = true
	animationPlayer.play("open")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		is_player_in_area = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is Player:
		is_player_in_area = false
