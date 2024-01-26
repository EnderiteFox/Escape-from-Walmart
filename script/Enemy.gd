extends Node3D
class_name Enemy

@export var SPEED: int = 20
@export var HEARING_RANGE: int = 20
@export var VIEW_RANGE: int = 20
@export var DAMAGE: int = 20

@onready var NavRegion: NavigationRegion3D = $"../../NavigationRegion3D"
@onready var HitBox: Area3D = $Area3D
@onready var ViewRayCast: RayCast3D = $View/RayCast3D
@onready var NavAgent: NavigationAgent3D = $NavigationAgent3D
@onready var Player: Player = $"../../Player"

var lastPlayerPos: Vector3 = self.position

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	ViewRayCast.target_position = Player.find_child("Pivot").position
	NavAgent.target_position = Player.position
	var destination: Vector3 = NavAgent.get_next_path_position()
	var directionVector = destination - self.position
	directionVector.y = 0
	directionVector = directionVector.normalized()
	self.look_at(self.position + directionVector)
	directionVector *= delta * SPEED
	self.position += directionVector
	see_player()

func see_player() -> void:
	var collider: Object = ViewRayCast.get_collider()
	var sees_player: bool = false if collider == null else collider is Player
	sees_player = false if (ViewRayCast.position - Player.position).length()\
	 > VIEW_RANGE else sees_player
	lastPlayerPos = Player.position if sees_player else lastPlayerPos

func _physics_process(delta: float) -> void:
	pass
