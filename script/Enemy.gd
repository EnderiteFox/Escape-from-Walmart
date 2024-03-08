extends StaticBody3D
class_name Enemy


@export_category("EnemyStats")
@export var SPEED: int = 20
@export var HEARING_RANGE: int = 20
@export var VIEW_RANGE: int = 20
@export var DAMAGE: int = 20
@export var FOV: float = 60


@export_category("AnimationConfig")
@export var WALKING_ANIMATION_NAME: String = ""
@export var WALKING_ANIMATION_SPEED: float = 1.0
@export var ATTACK_ANIMATION_NAME: String = ""
@export var ATTACK_ANIMATION_SPEED: float = 1.0


@onready var NavRegion: NavigationRegion3D = $"/root/LevelTemplate/NavigationRegion3D"
@onready var ViewRayCast: RayCast3D = $View/RayCast3D
@onready var NavAgent: NavigationAgent3D = $NavigationAgent3D
@onready var player: Player
@onready var PlayerEyes: Node3D
@onready var map: Map = $"/root/LevelTemplate/NavigationRegion3D/Map"
@onready var level: Level = $"/root/LevelTemplate"
@onready var animationPlayer: AnimationPlayer = get_node_or_null("Model/AnimationPlayer")


const ABANDON_TARGET_DISTANCE: float = 1.75
const STUN_TIME: float = 2.0
const SAFE_SPAWN_TIME: float = 1.0


var lastPlayerPos: Vector3
var targetPos: Vector3
var targetInit: bool = false
var chasePlayer: bool = false
var remainingStunTime: float = -1
var inAttackHitbox: bool = false
var timeSinceSpawn: float


func _ready() -> void:
	timeSinceSpawn = 0.0
	if animationPlayer != null:
		animationPlayer.animation_changed.connect(_on_animation_change)
		var animation: Animation = animationPlayer.get_animation(WALKING_ANIMATION_NAME)
		if animation != null:
			animation.loop_mode = Animation.LOOP_LINEAR
		animationPlayer.play(WALKING_ANIMATION_NAME, -1, SPEED * WALKING_ANIMATION_SPEED)
	(func():
		player = $/root/LevelTemplate/Player
		PlayerEyes = player.find_child("Pivot")
		lastPlayerPos = player.global_position
	).call_deferred()
	lastPlayerPos = Vector3()

func _process(delta: float) -> void:
	timeSinceSpawn += delta
	remainingStunTime -= delta
	_see_player()
	_move(delta)
	if not _is_stunned() and inAttackHitbox and timeSinceSpawn > SAFE_SPAWN_TIME:
		stun(STUN_TIME)
		level.on_enemy_hit_player(self)
		if animationPlayer != null:
			if animationPlayer.get_animation_list().has(ATTACK_ANIMATION_NAME):
				animationPlayer.play(ATTACK_ANIMATION_NAME, -1, ATTACK_ANIMATION_SPEED)
				if animationPlayer.get_animation_list().has(WALKING_ANIMATION_NAME):
					animationPlayer.animation_set_next(ATTACK_ANIMATION_NAME, WALKING_ANIMATION_NAME)
	if animationPlayer != null and not animationPlayer.is_playing() and not _is_stunned():
		animationPlayer.play(WALKING_ANIMATION_NAME, -1, SPEED * WALKING_ANIMATION_SPEED)

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
	var x_coord: float = randf_range(-map.map_x_width / 2.0, map.map_x_width / 2.0)
	var z_coord: float = randf_range(-map.map_z_width / 2.0, map.map_z_width / 2.0)
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
	lastPlayerPos = Vector3(player.global_position) if sees_player else lastPlayerPos
	chasePlayer = chasePlayer or sees_player

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

func stun(duration: float) -> void:
	if animationPlayer != null:
		animationPlayer.pause()
	remainingStunTime = duration

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		inAttackHitbox = true

func _on_attack_hitbox_body_exited(body: Node3D) -> void:
	if body is Player:
		inAttackHitbox = false

func _on_animation_change(oldAnimation: String, _newAnimation: String) -> void:
	if oldAnimation == ATTACK_ANIMATION_NAME:
		animationPlayer.play(WALKING_ANIMATION_NAME, -1, SPEED * WALKING_ANIMATION_SPEED)
