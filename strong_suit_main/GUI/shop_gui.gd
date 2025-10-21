class_name ShopGUI extends FullScreenGUI

enum {
	BUY,
	SELL
}

var inventory: Inventory = null
var state: int = -1

@onready var shop_type: Label = $"MarginContainer/PUT_MENU_HERE/Top/MarginContainer/HBoxContainer/ShopType"
@onready var shop_intro: Label = $"MarginContainer/PUT_MENU_HERE/Top/MarginContainer/HBoxContainer/ShopIntro"
@onready var gold: Gold = $"MarginContainer/PUT_MENU_HERE/Options/Gold"
@onready var description_label: Label = $"MarginContainer/PUT_MENU_HERE/Bottom/MarginContainer/DescriptionLabel"
@onready var options: Menu = $MarginContainer/PUT_MENU_HERE/Options
@onready var spell_shop_middle: SpellShopMiddle = $MarginContainer/PUT_MENU_HERE/SpellShopMiddle
@onready var items_shop_middle: ItemShopMiddle = $MarginContainer/PUT_MENU_HERE/ItemsShopMiddle
@onready var shop_menu: ShopMiddle = items_shop_middle
@onready var items: Menu = null

func _ready() -> void:
	set_main_menu(options)
	
	items_shop_middle.visible = !spell_shop_middle.visible
	if items_shop_middle.visible:
		shop_menu = items_shop_middle
	else:
		shop_menu = spell_shop_middle
	
	set_sub_menu(shop_menu.get_items_menu())
	Data.player_inventory.connect("item_updated", on_Player_Inventory_item_updated)
	description_label.text = ""

func set_inventory(_inventory: Inventory) -> void:
	inventory = _inventory
	shop_menu.set_items(inventory)
	inventory.connect("item_updated", on_Inventory_item_updated)
	match inventory.type:
		Inventory.DEALER:
			shop_type.text = "Card Dealer"
			shop_intro.text = "Something for everyone..."
		Inventory.MYSTIC:
			shop_type.text = "Fortune Teller"
			shop_intro.text = "Let us see what fate deals..."
		Inventory.SMITH:
			shop_type.text = "Forge Master"
			shop_intro.text = "Steel thyself against the odds..."
		Inventory.LIBRARIAN:
			shop_type.text = "Old Librarian"
			shop_intro.text = "Soldier or poet, pen or sword..."
		_:
			shop_type.text = "ERR: No Shop Type"
			shop_intro.text = "Missing shop designation :("
			


func _on_shop_menu_button_focused(button: BaseButton) -> void:
	pen_cursor.move_to_node(button)
	var item: Item = Data.items[button.text]
	shop_menu.update_shop_labels(item)
	description_label.text = item.desc

func _on_shop_menu_button_pressed(button: BaseButton) -> void:
	var item: Item = Data.items[button.text]
	var index: int = button.get_index()
	if state == BUY:
		if item.quantity > 0:
			if item.cost <= Data.player_gold:
				Data.player_inventory.add_item(item.duplicate_custom())
				inventory.remove_item_by_index(index, 1)
				Data.player_gold -= item.cost
	elif state == SELL:
		if item.quantity > 0:
			inventory.add_item(item.duplicate_custom())
			Data.player_inventory.remove_item_by_index(index, 1)
			Data.player_gold += item.cost - randf_range(0.1,0.5)
	shop_menu.update_shop_labels(item)
	description_label.text = item.desc

func _on_options_button_pressed(button: BaseButton) -> void:
	match button.text.to_lower():
		"buy":
			if sub_menu.get_buttons()[0].visible:
				sub_menu.button_focus()
			else:
				main_menu.button_focus()
			state = BUY
		"sell":
			if sub_menu.get_buttons()[0].visible:
				sub_menu.button_focus()
			else:
				main_menu.button_focus()
			state = SELL
		"exit":
			enable(false)

func _on_options_button_focused(button: BaseButton) -> void:
	super(button)
	match button.text.to_lower():
		"buy":
			shop_menu.set_items(inventory)
		"sell":
			shop_menu.set_items(Data.player_inventory)
		_:
			pass

func on_Inventory_item_updated(item: Item, index: int) -> void:
	if item.quantity == 0:
		shop_menu.set_items(inventory)
		if sub_menu.get_buttons()[0].visible:
			sub_menu.button_focus()
		else:
			main_menu.button_focus()
	shop_menu.update_shop_labels(item)
	description_label.text = item.desc

func on_Player_Inventory_item_updated(item: Item, index: int) -> void:
	if item.quantity == 0:
		shop_menu.set_items(Data.player_inventory)
		if sub_menu.get_buttons()[0].visible:
			sub_menu.button_focus()
		else:
			main_menu.button_focus()
	shop_menu.update_shop_labels(item)
	description_label.text = item.desc
