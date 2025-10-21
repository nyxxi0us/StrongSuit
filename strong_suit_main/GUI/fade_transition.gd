class_name FadeTransition extends CanvasLayer

signal finished()

var skip_next_fade_out: bool = false

@onready var color_rect: ColorRect = $ColorRect
var tween: Tween = null

func _ready() -> void:
	hide()

func start() -> void:
	tween.play()
	await tween.finished
	finished.emit()

func set_color(color: Color) -> void:
	var previous_alpha: float = color_rect.color.a
	color_rect.color = color
	color_rect.color.a = previous_alpha

func fade_out(color: Color = color_rect.color, duration: float = 0.5, skip: bool = false) -> void:
	show()
	if skip_next_fade_out:
		skip_next_fade_out = false
		finished.emit()
		return
	
	set_color(color)
	
	if skip:
		color_rect.color.a = 0.0
		return
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(color_rect, "color:a", 0.0, duration).set_trans(Tween.TRANS_CUBIC)
	start()

func fade_in(color: Color = color_rect.color, duration: float = 0.5, skip: bool = false) -> void:
	show()
	set_color(color)
	
	if skip:
		color_rect.color.a = 1.0
		return
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(color_rect, "color:a", 1.0, duration).set_trans(Tween.TRANS_CUBIC)
	start()
