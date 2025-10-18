class_name NPC extends Actor

const MOVE_DURATION_TIME: float = 1.5

@export var is_stationary: bool = false
@export var talk_text: Array[String] = ["I am not a player character,\ncan you believe it?", "Wow, a real hero!", "Sure is dark times these days", "Did you just land?"]

@onready var move_timer: Timer = $MoveTimer
@onready var wait_timer: Timer = $WaitTimer
@onready var talk_timer: Timer = $TalkTimer

var previous_facing: Vector2

func _enter_tree() -> void:
	await ready
	if !is_stationary:
		move_or_idle()

func _process(delta: float) -> void:
	if move_and_collide(facing*SPEED*delta):
		sprite_sheet_animation.idle()
		set_process(false)

func enable(on: bool) -> void:
	super(on)
	if on:
		move_or_idle(0.25)
	else:
		move_timer.stop()
		wait_timer.stop()

func move_or_idle(chance_to_move: float = 0.5) -> void:
	previous_facing = facing
	facing = Math.get_random_vector_1d()
	if facing != previous_facing:
		if randf() < chance_to_move:
			sprite_sheet_animation.play(facing)
			set_process(true)
				
			var move_duration: float = Math.add_with_random_spreadf(MOVE_DURATION_TIME, MOVE_DURATION_TIME * 0.5)
			move_timer.start(move_duration)
		else:
			sprite_sheet_animation.idle()
			set_process(false)
	wait_timer.start(randf_range(2,4))


func talk() -> void:
	if GlobalScript.dialogue_box and talk_timer.is_stopped():
		GlobalScript.dialogue_box.add_text([talk_text[randi_range(0,talk_text.size()-1)]])
		enable(false)
		GlobalScript.player.enable(false)
		await GlobalScript.dialogue_box.closed
		enable(true)
		GlobalScript.player.enable(true)
		talk_timer.start(1)
	else:
		talk_timer.stop()

func _on_move_timeout() -> void:
	set_process(false)
	

func _on_wait_timer_timeout() -> void:
	move_or_idle()
