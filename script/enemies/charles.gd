extends Enemy
class_name Charles

var limitations: Node3D
var playerLimitationCount: int = 0

func _ready() -> void:
	super._ready()
	limitations = map.find_child("CharlesLimitations")
	if limitations != null:
		for area in limitations.get_children():
			area.body_entered.connect(_on_player_enter_limitation)
			area.body_exited.connect(_on_player_leave_limitation)

func _get_random_map_point() -> Vector3:
	var point = super._get_random_map_point()
	while not _can_reach(point):
		point = super._get_random_map_point()
	return point

func _can_reach(pos: Vector3) -> bool:
	if limitations == null:
		return true
	for area in limitations.get_children():
		var collisionShape: CollisionShape3D = area.find_child("CollisionShape3D")
		if _is_in_box(collisionShape.shape, collisionShape.global_position, pos):
			return true
	return false

func _is_in_box(shape: BoxShape3D, boxPos: Vector3, pos: Vector3) -> bool:
	return pos.x >= boxPos.x - shape.size.x / 2 \
		or pos.x <= boxPos.x + shape.size.x / 2 \
		or pos.y >= boxPos.y - shape.size.y / 2 \
		or pos.y <= boxPos.y + shape.size.y / 2 \
		or pos.z >= boxPos.z - shape.size.z / 2 \
		or pos.z <= boxPos.z + shape.size.z / 2

func _player_is_in_fov() -> bool:
	return super._player_is_in_fov() and _player_is_reachable()

func _player_is_reachable() -> bool:
	return playerLimitationCount == 0

func _on_player_enter_limitation(body: Node3D) -> void:
	if body is Player:
		playerLimitationCount += 1

func _on_player_leave_limitation(body: Node3D) -> void:
	if body is Player:
		playerLimitationCount -= 1
