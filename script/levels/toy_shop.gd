extends Level
class_name ToyShop

@onready var environment: Environment = $/root/Level/WorldEnvironment.environment

func _ready() -> void:
	super._ready()
	environment.volumetric_fog_density = 0.05
