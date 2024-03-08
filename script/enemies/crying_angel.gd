extends Enemy
class_name CryingAngel

@onready var visibleNotifier: VisibleOnScreenNotifier3D = $VisibleOnScreenNotifier3D

@export var VISIBLE_UNSTUN_TIME: float = 0.1

var is_on_screen: bool = false
var can_move: bool = true
var visibleTime: float = -1

func _ready() -> void:
	super._ready()
	if visibleNotifier != null:
		visibleNotifier.screen_entered.connect(on_screen_enter)
		visibleNotifier.screen_exited.connect(on_screen_exit)
		animationPlayer.pause()

func _process(delta: float) -> void:
	super._process(delta)
	if visibleTime != -1:
		visibleTime += delta
	if not can_move and animationPlayer.is_playing():
		animationPlayer.pause()
	if is_on_screen and visibleTime >= VISIBLE_UNSTUN_TIME:
		become_visible()
		visibleTime = -1
	if not can_move and (not is_on_screen or not ViewRayCast.is_colliding() or not ViewRayCast.get_collider() is Player):
		become_not_visible()
	if can_move and is_on_screen and ViewRayCast.is_colliding() and ViewRayCast.get_collider() is Player:
		become_visible()

func on_screen_enter() -> void:
	is_on_screen = true
	visibleTime = 0.0

func on_screen_exit() -> void:
	is_on_screen = false
	become_not_visible()

func become_visible() -> void:
	animationPlayer.pause()
	can_move = false

func become_not_visible() -> void:
	animationPlayer.play(WALKING_ANIMATION_NAME, -1, SPEED * WALKING_ANIMATION_SPEED)
	can_move = true

func _is_visible() -> bool:
	return true if visibleNotifier == null else is_on_screen

func _is_stunned() -> bool:
	return super._is_stunned() or visibleNotifier == null or not can_move
