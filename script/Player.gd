extends CharacterBody3D

@onready var Camera := $Camera

const SPEED: int = 10

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	var direction: Vector2 = Input.get_vector("Left", "Right", "Forward", "Backward")
	self.velocity = Vector3(direction.x, 0, direction.y) * SPEED
