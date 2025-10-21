class_name ItemLabel extends Button

var item: Item = null

func set_item(_item: Item, shop: bool = false) -> void:
	item = _item
	if item:
		show()
		text = item.name
	else:
		hide()
