class_name FullScreenGUI extends Control

const CURSOR: PackedScene = preload("res://GUI/pen_cursor.tscn")

var enabled: bool = false
var main_menu: Menu = null
var sub_menu: Menu = null
var sub_sub_menu: Menu = null
var options_index: int = 0

@onready var pen_cursor: Cursor = $PenCursor

func _unhandled_input(event: InputEvent) -> void:
	if enabled and (event.is_action_pressed("ui_cancel") or event.is_action_pressed("Menu")):
		if main_menu and main_menu.menu_is_focused():
			enable(false)
		elif sub_menu and sub_menu.menu_is_focused():
			main_menu.button_focus() 
		elif sub_sub_menu and sub_sub_menu.menu_is_focused():
			sub_menu.button_focus()
		else:
			return

func set_main_menu(_menu: Menu) -> void:
	if !_menu:
		return
	main_menu = _menu
	main_menu.connect_to_buttons(main_menu.owner)
	enable(false)

func set_sub_menu(_menu: Menu) -> void:
	sub_menu = _menu
	sub_menu.connect_to_buttons(sub_menu.owner)
	enable(false)

func set_sub_sub_menu(_menu: Menu) -> void:
	sub_sub_menu = _menu
	sub_sub_menu.connect_to_buttons(sub_sub_menu.owner)
	enable(false)

func enable(on: bool) -> void:
	enabled = on
	set_visible(on)
	set_process_unhandled_input(on)
	
	if on:
		if main_menu:
			main_menu.button_focus(options_index)
	else:
		options_index = 0
	
	if GlobalScript.player:
		GlobalScript.player.enable(!on)

func _on_options_button_focused(button: BaseButton) -> void:
	if pen_cursor:
		pen_cursor.move_to_node(button)
		options_index = button.get_index()
