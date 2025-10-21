extends FieldSubMenu

@onready var config_menu: Menu = $MarginContainer/PUT_MENU_HERE/Options/MarginContainer/HBoxContainer/ConfigMenu
@onready var description_label: Label = $MarginContainer/PUT_MENU_HERE/Bottom/MarginContainer/DescriptionLabel

func _ready() -> void:
	super()
	set_sub_menu(config_menu)

func _on_options_button_focused(button: BaseButton) -> void:
	super(button)

func _on_options_button_pressed(_button: Button) -> void:
	pass
