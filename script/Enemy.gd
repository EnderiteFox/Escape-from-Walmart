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
@onready var PlayerEyes: Node3D = $"../../Player/Pivot"

const FOV: float = 60

var lastPlayerPos: Vector3
var targetPos: Vector3
var chasePlayer: bool = false

func _ready() -> void:
	lastPlayerPos = Player.global_position

func _process(delta: float) -> void:
	_see_player()
	_move(delta)

func _move(delta: float) -> void:
	if chasePlayer:
		_chase_player(delta)
	else:
		_random_walk(delta)
		
func _chase_player(delta: float) -> void:
	NavAgent.target_position = Player.global_position
	var destination: Vector3 = NavAgent.get_next_path_position()
	var directionVector: Vector3 = destination - self.global_position
	directionVector.y = 0
	directionVector = directionVector.normalized()
	directionVector *= delta * SPEED
	self.look_at(self.global_position + directionVector)
	self.global_position += directionVector

func _random_walk(delta: float) -> void:
	pass

func _see_player() -> void:
	ViewRayCast.target_position = ViewRayCast.to_local(PlayerEyes.global_position)
	ViewRayCast.force_raycast_update()
	var sees_player: bool = ViewRayCast.is_colliding() and ViewRayCast.get_collider() is Player
	sees_player = sees_player and ($View.global_position - \
		Player.global_position).length() <= VIEW_RANGE \
		and _player_is_in_fov()
	lastPlayerPos = Player.global_position if sees_player else lastPlayerPos
	chasePlayer = chasePlayer or sees_player

func _player_is_in_fov() -> bool:
	var direction := Vector3(sin(self.global_rotation.y), 0, -cos(self.global_rotation.y))
	direction = direction.normalized()
	var playerDirection: Vector3 = $View.to_local(PlayerEyes.global_position)
	playerDirection.y = 0
	playerDirection = playerDirection.normalized()
	var angle: float = acos(direction.dot(playerDirection))
	angle = rad_to_deg(abs(angle))
	return angle <= FOV

func _physics_process(delta: float) -> void:
	pass
