class_name DialogueBox extends NinePatchRect

signal closed()

@export var handle_input: bool = true

@onready var dialogue: Label = $MarginContainer/Dialogue
@onready var text: String = dialogue.text

var lines: Array = []

func _enter_tree() -> void:
	GlobalScript.dialogue_box = self

func _ready() -> void:
	#GlobalScript.player.moved.connect(_on_player_moved)
	clear()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") ||  event.is_action_pressed("ui_cancel"):
		advance()
	else:
		return

func clear() -> void:
	dialogue.text = ""
	hide()
	set_process_input(false)
	closed.emit()

func advance() -> void:
	if !lines:
		clear()
		return
	if dialogue.text != "":
		dialogue.text += "\n"
	else:
		show()
		set_process_input(handle_input)
	dialogue.text += lines.pop_front()

func add_text(newtext: Array) ->void:
	if newtext:
		lines.append_array(newtext)
		advance()
