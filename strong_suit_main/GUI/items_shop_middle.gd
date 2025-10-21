class_name ItemShopMiddle extends ShopMiddle

@onready var in_stock: Label = $MarginContainer/HBoxContainer/Quantities/InStock
@onready var have: Label = $MarginContainer/HBoxContainer/Quantities/Have

var inventory: Inventory = null

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

func set_items(_inventory:Inventory):
	super(_inventory)
	in_stock.text = "In Stock:"
	have.text = "Have:"
