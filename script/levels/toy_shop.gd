extends Map
class_name ToyShop

@onready var environment: Environment = $"../../WorldEnvironment".environment

func _ready() -> void:
	super._ready()
	environment.volumetric_fog_density = 0.05
