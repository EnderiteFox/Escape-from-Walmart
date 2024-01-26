extends Node3D
class_name Enemy

@export var SPEED: int = 20
@export var HEARING_RANGE: int = 20
@export var VIEW_RANGE: int = 20
@export var DAMAGE: int = 20

@onready var NavRegion: NavigationRegion3D = $"../../NavigationRegion3D"
@onready var HitBox: Area3D = $Area3D
@onready var NavAgent: NavigationAgent3D = $NavigationAgent3D
@onready var Player: Player = $"../../Player"

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	NavAgent.target_position = Player.position
	var destination: Vector3 = NavAgent.get_next_path_position()
	var directionVector = destination - self.position
	directionVector.y = 0
	directionVector = directionVector.normalized()
	directionVector *= delta * SPEED
	self.position += directionVector

func _physics_process(delta: float) -> void:
	pass
