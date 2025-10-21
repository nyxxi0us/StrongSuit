class_name FieldSubMenu extends FullScreenGUI

signal closing(GUI: FullScreenGUI)

@onready var options: Menu = get_node_or_null("MarginContainer/PUT_MENU_HERE/Options")
@onready var title: Label = %Title


func _ready() -> void:
	set_main_menu(options)
	title.text = name.right(-"SubMenu".length())

func enable(on: bool) -> void:
	enabled = on
	set_visible(on)
	
	if on:
		if main_menu:
			main_menu.button_focus(options_index)
	else:
		options_index = 0
		closing.emit(self)
