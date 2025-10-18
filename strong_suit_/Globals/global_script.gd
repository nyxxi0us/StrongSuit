extends Node

const GAME_SIZE: Vector2 = Vector2(320,180)
const CELL_SIZE: Vector2 = Vector2(16,16)
const DEFAULT_TIMER: float = 0.5
const NULL_CELL: Vector2 = Vector2.ZERO

var current_map: TileMapLayer = null
var camera: Camera2D = null
var music_position: float = 0.0
var player: Player = null
var dialogue_box: DialogueBox = null

func _ready() -> void:
	randomize()
