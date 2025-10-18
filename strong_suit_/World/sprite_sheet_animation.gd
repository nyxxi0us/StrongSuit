class_name SpriteSheetAnimation extends Sprite2D

@export var idle_frame: int = 1
@export var frame_offset: int = 0
@export var separation: Vector2 = Vector2(16, 16)
@export var frame_duration: float = 0.25

var character_index: Vector2
var indexed_position: Vector2
var facing: int = 0
var frame_current: int = idle_frame
var speed_scale: float = 1

@onready var frame_size: Vector2
@onready var frame_max: int = 4
@onready var character_area: Vector2 
@onready var frame_advance_timer: Timer = $FrameAdvanceTimer

func _ready() -> void:
	frame_size = texture.region.size if texture else separation
	character_area = Vector2((frame_max - 1) * frame_size.x, Math.Facing.size() * frame_size.y)
	frame_advance_timer.wait_time = frame_duration
	

func set_sprite_frame(n: int) -> void:
	frame_current = wrapi(n, 0, frame_max)
	
	var new_frame = idle_frame if frame_current == 3 else frame_current
	texture.region.position = indexed_position + Vector2(new_frame, facing) * frame_size

func set_frame_max() -> void:
	frame_max = texture.atlas.get_width() / frame_size.x

func set_new_texture(tex: Texture) -> void:
	if !tex:
		return
	if tex is AtlasTexture and tex.atlas != texture.atlas:
		set_texture(tex)
		set_frame_max()
		set_sprite_frame(idle_frame)
	

func set_character_index(pos: Vector2) -> void:
	character_index = pos
	indexed_position = character_index * character_area
	

func set_speed_scale(value: float) -> void:
	if !is_equal_approx(speed_scale,value):
		
		speed_scale = value
		frame_advance_timer.wait_time = frame_duration / value
		set_sprite_frame(frame_current)

func set_facing(dir: Vector2) -> void:
	var facing_previous: int = facing
	facing = Math.convert_vector2_to_facing_int(dir)
	if facing != facing_previous:
		set_sprite_frame(frame_current)
	#if is_running:
		#set_texture(Textures.RUN)
	#else:
		#set_texture(Textures.WALK)

func play(direction: Vector2) -> void:
	if frame_advance_timer.is_stopped():
		set_sprite_frame(0)
		frame_advance_timer.start()
	set_facing(direction)

func idle() -> void:
	set_sprite_frame(idle_frame)
	frame_advance_timer.stop()

func _on_frame_advance_timer_timeout() -> void:
	frame_current +=1
	set_sprite_frame(frame_current)
