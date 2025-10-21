class_name Actor extends CharacterBody2D

const IDLE_FRAME: int = 1
const SPEED: int = 60

var facing: Vector2 = Vector2.ZERO
var enabled: bool = true

@export var sprite_atlas: AtlasTexture = null
@export var character_index: Vector2

@onready var sprite_sheet_animation: SpriteSheetAnimation = $Mask/SpriteSheetAnimation
@onready var mask: Sprite2D = $Mask

func _ready() -> void:
	if sprite_atlas:
		sprite_sheet_animation.set_new_texture(sprite_atlas)
	sprite_sheet_animation.set_character_index(character_index)
	sprite_sheet_animation.play(Vector2.DOWN)
	sprite_sheet_animation.idle()
	mask_sprite(false)

func mask_sprite(on: bool = true) -> void:
	sprite_sheet_animation.position.y = 2 if on else -4

func enable(on: bool) -> void:
	enabled = on
	set_process(on)
	set_process_input(on)
	if !on:
		sprite_sheet_animation.idle()

func set_facing(direction: Vector2, animating: bool) -> void:
	facing = direction
	sprite_sheet_animation.play(direction)
	if !animating:
		sprite_sheet_animation.idle()
