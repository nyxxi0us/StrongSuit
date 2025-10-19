class_name Cursor extends TextureRect

const OFFSET: Vector2 = Vector2(-16,-8)

var counter: int = 0

func _ready() -> void:
	set_process(false)

func _process(_delta: float) -> void:
	counter += 1
	if counter % 15 == 0:
		visible = !visible

func move_to_node(node: Control) -> void:
	global_position = node.global_position + OFFSET

func set_blink(on: bool) -> void:
	counter = 0
	set_process(on)
	if !on:
		visible = true
