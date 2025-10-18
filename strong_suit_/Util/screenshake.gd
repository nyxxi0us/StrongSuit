class_name ScreenShake extends Node

@export var decay: float = 0.8
@export var max_offset: Vector2 = Vector2(100,75)
@export var max_roll: float = 0.1
@export var target_node_path: NodePath

var trauma: float = 0.0
var trauma_power: int = 1
var noise_y: = 0

@onready var camera: Camera2D = get_parent()
@onready var noise: FastNoiseLite = FastNoiseLite.new()
@onready var target_node: Node2D = get_node_or_null(target_node_path)

func _ready() -> void:
	noise.seed = -46329376
	noise.noise_type = noise.TYPE_SIMPLEX_SMOOTH
	noise.fractal_octaves = 2

func add_trauma(amount: float = 0.25) -> void:
	trauma =min(trauma + amount, 1.0)

func _process(delta: float) -> void:
	if trauma:
		trauma = max(trauma - decay*delta, 0)
		shake()

func shake() -> void:
	var amount: float = pow(trauma, trauma_power)
	
	noise_y +=1
	camera.offset.x = max_offset.x *amount * noise.get_noise_2d(noise.seed*2, noise_y)
	camera.offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)
