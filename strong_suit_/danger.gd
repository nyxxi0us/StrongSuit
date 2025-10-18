class_name Danger extends Node

signal limit_reached()

@export var limit_base: int = 400
@export var enabled: bool = true
@export var show_debug_text: bool = true

var limit: int = 0

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var debug_label: Label = $CanvasLayer/MarginContainer/Limit

func _ready() -> void:
	set_limit()
	
	if show_debug_text:
		canvas_layer.show()
	else:
		canvas_layer.queue_free()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.pressed:
		match event.keycode:
			KEY_D:
				enabled = !enabled
			KEY_E:
				canvas_layer.visible = !canvas_layer.visible

func set_limit() -> void:
	limit = randi_range(limit_base * 0.5, limit_base * 1.5)
	if show_debug_text:
			debug_label.text = str(limit)

func countdown(amount: int = 1) -> void:
	if enabled:
		limit -= amount
		
		if limit <= 0:
			limit_reached.emit()
			set_limit()
		if show_debug_text:
			debug_label.text = str(limit)
