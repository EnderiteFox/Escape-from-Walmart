extends CharacterBody3D
class_name Player


const GRAVITY: float = -24.8
const MAX_SPEED: float = 10
const ACCEL: float = 2.25

const MAX_SPRINT_SPEED: float = 15
const SPRINT_ACCEL: float = 9
var is_sprinting: bool = false

var dir: Vector3 = Vector3()
var health: int = MAX_HEALTH
var timeSinceLastRegen: float = 0.0
var targetRotation: Vector2
var previousBobbleX: float = 0.0

const DEACCEL: float = 16
const MAX_SLOPE_ANGLE: float = 40
const MAX_HEALTH: int = 100
const REGEN_TIME: float = 1.0
const REGEN_AMOUNT: int = 1
const MOUSE_SENSITIVITY: float = 0.15
const RIGHT_STICK_SENSITIVITY: float = 2
const ROTATION_SMOOTHING: float = 0.75
const HEAD_BOBBLE_SPEED: float = 0.03
const HEAD_BOBBLE_INTENSITY: float = 0.1

@onready var Camera: Camera3D = $Pivot/Camera
@onready var Pivot: Node3D = $Pivot
@onready var healthDisplay: HealthDisplay = $HealthDisplay
@onready var map: Map = $"../NavigationRegion3D/Map"

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	targetRotation = Vector2(Pivot.rotation.x, self.rotation.y)

func _process(delta: float) -> void:
	$HealthDisplay/HBoxContainer/Label.text = "PV: " + str(health) + "/" + str(MAX_HEALTH)
	$HealthDisplay/HBoxContainer/TextureProgressBar.value = health
	timeSinceLastRegen += delta
	if timeSinceLastRegen > REGEN_TIME:
		health += REGEN_AMOUNT
		timeSinceLastRegen = 0.0
	health = clamp(health, 0, MAX_HEALTH)
	$DebugLight.visible = LevelManager.debugLight
	
func _physics_process(delta: float) -> void:
	process_input(delta)
	process_movement(delta)
	
func process_input(_delta: float) -> void:
	# Walking
	dir = Vector3()
	var cam_xform = Camera.get_global_transform()
	
	var input_movement_vector: Vector2 = Vector2()
	
	input_movement_vector = Input.get_vector("Left", "Right", "Backward", "Forward")
	
	# Basis vectors are already normalized
	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x
	
	
	var camera_movement_vector: Vector2 = Input.get_vector( \
		"Camera_Right", "Camera_Left", "Camera_Down", "Camera_Up")
	targetRotation.x += deg_to_rad(camera_movement_vector.y * RIGHT_STICK_SENSITIVITY)
	targetRotation.x = -PI/2 + 0.05 if targetRotation.x < -PI/2 + 0.05 else targetRotation.x
	targetRotation.x = PI/2 - 0.05 if targetRotation.x > PI/2 - 0.05 else targetRotation.x
	targetRotation.y += deg_to_rad(camera_movement_vector.x * RIGHT_STICK_SENSITIVITY)
	
	Pivot.rotation.x += (targetRotation.x - Pivot.rotation.x) * (1 - ROTATION_SMOOTHING)
	if targetRotation.y > 2*PI: targetRotation.y -= 2*PI
	if targetRotation.y < 0: targetRotation.y += 2*PI
	if self.rotation.y > 2*PI: self.rotation.y -= 2*PI
	if self.rotation.y < 0: self.rotation.y += 2*PI
	
	var rotationYDelta = targetRotation.y - self.rotation.y
	if abs(rotationYDelta) > PI: rotationYDelta += -2*PI if rotationYDelta > 0 else 2*PI
	self.rotation.y += rotationYDelta * ((1 - ROTATION_SMOOTHING) if abs(rotationYDelta) < PI/2 else 1-0.7)
	
	
	# Sprinting
	is_sprinting = Input.is_action_pressed("Sprint")


func process_movement(delta) -> void:
	dir.y = 0
	dir = dir.normalized()
	
	velocity.y += delta * GRAVITY
	
	var hvel = velocity
	hvel.y = 0
	
	var target: Vector3 = dir
	target *= MAX_SPEED if not is_sprinting else MAX_SPRINT_SPEED
	
	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL
	
	hvel = hvel.lerp(target, accel * delta)
	velocity.x = hvel.x
	velocity.z = hvel.z
	
	var speed = velocity.length() if velocity.length() > 1 else 0.0
	Pivot.position.y += (sin(previousBobbleX + speed * HEAD_BOBBLE_SPEED) \
		- sin(previousBobbleX)) * HEAD_BOBBLE_INTENSITY
	previousBobbleX += speed * HEAD_BOBBLE_SPEED
	
	floor_max_angle = deg_to_rad(MAX_SLOPE_ANGLE)
	floor_snap_length = 0.05
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		targetRotation.x += -deg_to_rad(event.relative.y * MOUSE_SENSITIVITY)
		targetRotation.y += -deg_to_rad(event.relative.x * MOUSE_SENSITIVITY)
		
		targetRotation.x = clamp(targetRotation.x, -89, 89)

func damage(damageAmount: int) -> void:
	health -= damageAmount
	timeSinceLastRegen = 0.0
	healthDisplay.on_player_hurt()
	if health <= 0 and not LevelManager.invincibility:
		LevelManager.on_death()
