class_name ItemShopMiddle extends ShopMiddle

@onready var items_menu: Menu = $MarginContainer/HBoxContainer/ItemsMenu
@onready var in_stock: Label = $MarginContainer/HBoxContainer/Quantities/InStock
@onready var have: Label = $MarginContainer/HBoxContainer/Quantities/Have

var inventory: Inventory = null

func _ready() -> void:
	set_shop_menu(items_menu)

func set_items(_inventory: Inventory) -> Array:
	inventory = _inventory
	var items = inventory.get_items()
	var items_size: int = items.size()
	var item_buttons: Array = items_menu.get_buttons()
	for i in range(item_buttons.size()):
		var item_button: ItemLabel = item_buttons[i]
		var item: Item = null
		if i<items.size():
			item = items[i]
		item_button.set_item(item,true)
	return items

func update_shop_labels(current_item: Item) -> void:
	var shop_item: Item = inventory.get_item_by_name(current_item.name)
	var held_item: Item = Data.player_inventory.get_item_by_name(current_item.name)
	
	if shop_item:
		in_stock.text = "In Stock: " + str(shop_item.quantity)
	else:
		in_stock.text = "In Stock: None"
	
	if held_item:
		have.text = "Have: " + str(held_item.quantity)
	else:
		have.text = "Have: None"
