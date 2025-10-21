class_name ItemLabel extends Button

@onready var quantity: Label = $Quantity

var item: Item = null

func set_item(_item: Item, shop: bool = false) -> void:
	item = _item
	if item:
		show()
		text = item.name
		if shop:
			quantity.text = str(item.cost)
			quantity.add_theme_color_override("font_color",Color.GOLD)
		else:
			quantity.text = "x"+ str(item.quantity)
			quantity.add_theme_color_override("font_color",Color.WEB_MAROON)
	else:
		hide()
