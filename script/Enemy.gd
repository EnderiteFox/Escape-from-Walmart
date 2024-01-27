extends StaticBody3D
class_name Enemy

@export var SPEED: int = 20
@export var HEARING_RANGE: int = 20
@export var VIEW_RANGE: int = 20
@export var DAMAGE: int = 20
@export var FOV: float = 60

@onready var NavRegion: NavigationRegion3D = $"../../NavigationRegion3D"
@onready var ViewRayCast: RayCast3D = $View/RayCast3D
@onready var NavAgent: NavigationAgent3D = $NavigationAgent3D
@onready var Player: Player = $"../../Player"
@onready var PlayerEyes: Node3D = $"../../Player/Pivot"
@onready var Map: Map = $"../../NavigationRegion3D/Map"
@onready var Level: Level = $"../.."

const ABANDON_TARGET_DISTANCE: float = 1.75
const STUN_TIME: float = 2.0

var lastPlayerPos: Vector3
var targetPos: Vector3
var targetInit: bool = false
var chasePlayer: bool = false
var remainingStunTime: float = -1
var inAttackHitbox: Array[Node3D]

func _ready() -> void:
	lastPlayerPos = Player.global_position

func _process(delta: float) -> void:
	remainingStunTime -= delta
	_see_player()
	_move(delta)
	if not _is_stunned():
		for body in inAttackHitbox:
			if body is Player:
				_stun()
				Level.on_enemy_hit_player(self)

func _move(delta: float) -> void:
	if _is_stunned():
		return
	if chasePlayer:
		_chase_player(delta)
	else:
		_random_walk(delta)
		
func _chase_player(delta: float) -> void:
	if lastPlayerPos.distance_to(self.global_position) <= ABANDON_TARGET_DISTANCE:
		chasePlayer = false
		return
	_move_to_point(delta, lastPlayerPos)

func _get_random_map_point() -> Vector3:
	var x_coord: float = randf_range(-Map.map_x_width / 2.0, Map.map_x_width / 2.0)
	var z_coord: float = randf_range(-Map.map_z_width / 2.0, Map.map_z_width / 2.0)
	return NavigationServer3D \
		.map_get_closest_point(NavRegion.get_navigation_map(), Vector3(x_coord, 0, z_coord))

func _random_walk(delta: float) -> void:
	if targetPos == Vector3.ZERO:
		targetPos = _get_random_map_point()
		return
	if targetPos.distance_to(self.global_position) <= ABANDON_TARGET_DISTANCE:
		targetPos = _get_random_map_point()
	_move_to_point(delta, targetPos)

func _see_player() -> void:
	ViewRayCast.target_position = ViewRayCast.to_local(PlayerEyes.global_position)
	ViewRayCast.force_raycast_update()
	var sees_player: bool = ViewRayCast.is_colliding() and ViewRayCast.get_collider() is Player
	sees_player = sees_player and ($View.global_position - \
		PlayerEyes.global_position).length() <= VIEW_RANGE \
		and _player_is_in_fov()
	lastPlayerPos = Vector3(Player.global_position) if sees_player else lastPlayerPos
	chasePlayer = chasePlayer or sees_player
	$OmniLight3D.light_color = Color.RED if sees_player else Color.WHITE

func _player_is_in_fov() -> bool:
	var direction := Vector3.FORWARD
	var playerDirection: Vector3 = $View.to_local(PlayerEyes.global_position)
	playerDirection.y = 0
	playerDirection = playerDirection.normalized()
	var angle: float = rad_to_deg(acos(direction.dot(playerDirection)))
	angle = abs(angle)
	return angle <= FOV

func _move_to_point(delta: float, target: Vector3) -> void:
	if NavAgent.is_navigation_finished():
		targetPos = _get_random_map_point()
		target = targetPos
	NavAgent.target_position = target
	var destination: Vector3 = NavAgent.get_next_path_position()
	var directionVector: Vector3 = destination - self.global_position
	directionVector.y = 0
	directionVector = directionVector.normalized()
	directionVector *= delta * SPEED
	self.look_at(self.global_position + directionVector)
	self.global_position += directionVector

func _is_stunned() -> bool:
	return remainingStunTime > 0

func _stun() -> void:
	remainingStunTime = STUN_TIME

func _physics_process(delta: float) -> void:
	pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	inAttackHitbox.append(body)

func _on_attack_hitbox_body_exited(body: Node3D) -> void:
	inAttackHitbox.erase(body)
