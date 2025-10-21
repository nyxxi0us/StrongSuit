class_name ShopMiddle extends NinePatchRect

signal on_menu_button_focused(button: BaseButton)
signal on_menu_button_pressed(button: BaseButton)

@onready var items_menu: Menu = $MarginContainer/HBoxContainer/ItemsMenu
@onready var levels: VBoxContainer = null
@onready var prices: Array = $MarginContainer/HBoxContainer/Prices.get_children()

func set_items(_inventory: Inventory) -> Array:
	var items = _inventory.get_items()
	var item_buttons: Array = items_menu.get_buttons()
	for i in range(item_buttons.size()):
		var item_button: ItemLabel = item_buttons[i]
		var item: Item = null
		var item_price = prices[i]
		if i < items.size():
			item = items[i]
			item_price.show()
			item_price.text = "x"+ str(item.cost)
			item_price.add_theme_color_override("font_color",Color.GOLDENROD)
			if item.name.begins_with("Tome of ") and levels:
				var levels_list = levels.get_children()
				var item_level = levels_list[i]
				item_level.text = Data.spells.get(item.name.right("Tome of ".length())).level
		else:
			item_price.hide()
		item_button.set_item(item, true)
		

	return items

func set_shop_menu(_menu: ShopMiddle) -> void:
	_menu.connect_to_buttons(self)

func get_shop_menu() -> ShopMiddle:
	return self

func get_items_menu() -> Menu:
	return items_menu

func _on_shop_menu_button_pressed(button: BaseButton) -> void:
	on_menu_button_pressed.emit(button)

func _on_shop_menu_button_focused(button: BaseButton) -> void:
	on_menu_button_focused.emit(button)
