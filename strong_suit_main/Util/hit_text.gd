class_name HitText extends Label

enum {
	FLOATING,
	BOUNCING
}

const SPEED: int = 60
const BOUNCE_MAX: int = 4

var hspeed: float = randf_range(-1, 1)
var vspeed: float = randf_range(-2, 0)
var gravity: float = -0.15
var bounce_count: int = 0
var ystart: float = 0.0
var fly_distance: float = 32

@onready var _tween: Tween = get_tree().create_tween() 

func _process(delta: float) -> void:
	vspeed -= gravity
	global_position += Vector2(hspeed,vspeed) * SPEED * delta
	
	if global_position.y > ystart:
		bounce()

func init(amount: int, target: Control, type: int) -> void:
	if target == null:
		queue_free()
		return
	
	text = str(abs(amount)) if amount != 0 else "MISS"
	
	if amount > 0:
		modulate = Color.GREEN
	elif amount < 0:
		modulate = Color.RED
	else:
		modulate = Color.WHITE
	
	global_position = target.global_position + target.size * 0.5 
	ystart = global_position.y
	
	if type == BOUNCING:
		set_process(true)
	else:
		set_process(false)
		float_up_and_fade_out()

func float_up_and_fade_out() -> void:
	_tween.tween_property(self,"global_position:y", ystart-fly_distance,1.0)
	await _tween.finished
	_tween.kill()
	queue_free()

func bounce() -> void:
	vspeed = -vspeed
	bounce_count += 1
	if bounce_count >= BOUNCE_MAX:
		queue_free()
		
