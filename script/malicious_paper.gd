extends Node

@onready var PaperFront: Area3D = $PaperFront
@onready var WatchTimer: Timer = $WatchTimer
@onready var ExitPaperZone: Area3D = $ExitPaperZone
@onready var TurnBackNotifier: VisibleOnScreenNotifier3D = $TurnBackNotifier
@onready var SoundEffect: AudioStreamPlayer3D = $Laitier/SoundEffect
@onready var Laitier: Enemy = $Laitier
@onready var MusicPlayer: AudioStreamPlayer = $/root/LevelTemplate/AudioStreamPlayer


var player: Player
var isPlayerInside := false
var isPlayerWatchingPaper := false

var hasWatched := false
var turnedBack := false

const PAPER_VIEW_ANGLE: float = deg_to_rad(30)

func _ready() -> void:
	PaperFront.body_entered.connect(
		func(body) : if body is Player: isPlayerInside = true
	)
	PaperFront.body_exited.connect(
		func(body) : if body is Player: isPlayerInside = false
	)
	(func() : player = $"/root/LevelTemplate/Player").call_deferred()
	WatchTimer.start()
	WatchTimer.set_paused(true)
	WatchTimer.timeout.connect(_on_watch_timer_timeout)
	ExitPaperZone.body_entered.connect(_on_exit_paper_zone)
	TurnBackNotifier.screen_entered.connect(_on_turn_back)
	

func _process(_delta: float) -> void:
	if (player == null): return
	var playerRotation = player.rotation.y
	while (playerRotation < 0): playerRotation += 2*PI
	while (playerRotation > 2*PI): playerRotation -= 2*PI
	isPlayerWatchingPaper = playerRotation > 1.5*PI - PAPER_VIEW_ANGLE \
		and playerRotation < 1.5*PI + PAPER_VIEW_ANGLE
	_process_timer()
	if not hasWatched or not turnedBack: Laitier.stun(0.5)
	if turnedBack: MusicPlayer.stream_paused = true

func _process_timer() -> void:
	if hasWatched: return
	if isPlayerWatchingPaper and isPlayerInside:
		WatchTimer.set_paused(false)
	else:
		WatchTimer.start()
		WatchTimer.set_paused(true)

func _on_watch_timer_timeout() -> void:
	hasWatched = true
	Laitier.visible = true
	
func _on_exit_paper_zone(body: Node3D) -> void:
	if not body is Player: return
	if turnedBack or not hasWatched: return
	_on_turn_back_trigger()

func _on_turn_back() -> void:
	if turnedBack or not hasWatched: return
	_on_turn_back_trigger()

func _on_turn_back_trigger() -> void:
	turnedBack = true
	SoundEffect.play()
	var pos: Vector3 = Laitier.global_position
	self.remove_child(Laitier)
	$"/root/LevelTemplate/EnemyContainer".add_child(Laitier)
	Laitier.global_position = pos
