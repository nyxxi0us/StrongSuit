class_name ShopMiddle extends NinePatchRect

signal on_menu_button_focused(button: BaseButton)
signal on_menu_button_pressed(button: BaseButton)

@onready var shop_menu: Menu = null

func set_shop_menu(_menu: Menu) -> void:
	shop_menu = _menu
	shop_menu.connect_to_buttons(self)

func get_shop_menu() -> Menu:
	return shop_menu

func _on_shop_menu_button_pressed(button: BaseButton) -> void:
	on_menu_button_pressed.emit(button)

func _on_shop_menu_button_focused(button: BaseButton) -> void:
	on_menu_button_focused.emit(button)
