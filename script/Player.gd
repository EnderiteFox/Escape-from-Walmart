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

const DEACCEL: float = 16
const MAX_SLOPE_ANGLE: float = 40
const MAX_HEALTH: int = 100
const REGEN_TIME: float = 1.0
const REGEN_AMOUNT: int = 1

@onready var Camera: Camera3D = $Pivot/Camera
@onready var Pivot: Node3D = $Pivot
@onready var healthDisplay: HealthDisplay = $HealthDisplay

var MOUSE_SENSITIVITY: float = 0.15
const RIGHT_STICK_SENSITIVITY: float = 2

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	$HealthDisplay/HBoxContainer/Label.text = "PV: " + str(health) + "/" + str(MAX_HEALTH)
	$HealthDisplay/HBoxContainer/TextureProgressBar.value = health
	timeSinceLastRegen += delta
	if timeSinceLastRegen > REGEN_TIME:
		health += REGEN_AMOUNT
		timeSinceLastRegen = 0.0
	health = clamp(health, 0, MAX_HEALTH)
	
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
	Pivot.rotate_x(deg_to_rad(camera_movement_vector.y * RIGHT_STICK_SENSITIVITY))
	self.rotate_y(deg_to_rad(camera_movement_vector.x * RIGHT_STICK_SENSITIVITY))
	
	# Capturing/Freeing the cursor
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
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
	floor_max_angle = deg_to_rad(MAX_SLOPE_ANGLE)
	floor_snap_length = 0.05
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		Pivot.rotate_x(-deg_to_rad(event.relative.y * MOUSE_SENSITIVITY))
		self.rotate_y(-deg_to_rad(event.relative.x * MOUSE_SENSITIVITY))
		
		var camera_rot: Vector3 = Pivot.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -90, 90)
		Pivot.rotation_degrees = camera_rot

func damage(damageAmount: int) -> void:
	health -= damageAmount
	timeSinceLastRegen = 0.0
	healthDisplay.on_player_hurt()
