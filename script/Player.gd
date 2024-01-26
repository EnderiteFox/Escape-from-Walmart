extends CharacterBody3D


const GRAVITY: float = -24.8
const MAX_SPEED: float = 20
const JUMP_SPEED: float = 18
const ACCEL: float = 4.5

const MAX_SPRINT_SPEED: float = 30
const SPRINT_ACCEL: float = 18
var is_sprinting: bool = false

var dir: Vector3 = Vector3()

const DEACCEL: float = 16
const MAX_SLOPE_ANGLE: float = 40

@onready var Camera: Camera3D = $Pivot/Camera
@onready var Pivot: Node3D = $Pivot

var MOUSE_SENSITIVITY: float = 0.15

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
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
	
	# Jumping
	if is_on_floor():
		if Input.is_action_just_pressed("movement_jump"):
			velocity.y = JUMP_SPEED
	
	# Capturing/Freeing the cursor
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Sprinting
	is_sprinting = Input.is_action_pressed("movement_sprint")


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
