extends FieldSubMenu

signal item_selected(item: Item)

enum {
	USE,
	SORT,
	REMOVE
}

@onready var items_menu: Menu = $MarginContainer/PUT_MENU_HERE/Middle/MarginContainer/HBoxContainer/ItemsMenu
@onready var description_label: Label = $MarginContainer/PUT_MENU_HERE/Bottom/MarginContainer/DescriptionLabel

var state: int = -1

func _ready() -> void:
	super()
	set_sub_menu(items_menu)

func enable(on: bool) -> void:
	super(on)
	if on:
		update_item_buttons()

func update_item_buttons() -> void:
	var item_buttons: Array = items_menu.get_buttons()
	for i in range(item_buttons.size()):
		var item_button: ItemLabel = item_buttons[i]
		var item: Item = Data.player_inventory.get_item_by_index(i)
		if i < Data.player_inventory.items.size():
			item_button.set_item(item)
		else:
			item_button.hide()

func return_from_item_use() -> void:
	show()
	update_item_buttons()
	if Data.player_inventory.empty():
		main_menu.button_focus()
	else:
		sub_menu.button_focus()

func set_description(item: Item) -> void:
	if !item:
		description_label.text = ""
		return
	description_label.text = item.desc

func _on_itemsmenu_button_focused(button: BaseButton) -> void:
	pen_cursor.move_to_node(button)
	var item: Item = Data.items[button.text]
	set_description(item)

func _on_itemsmenu_button_pressed(button: BaseButton) -> void:
	var item: Item =  Data.player_inventory.get_item_by_index(button.get_index())
	if item.type == Item.Type.CARD:
		match item.name:
#			Add cards to deck
			"Random Card":
				pass
			"Random Wnd. Card":
				pass
			"Random Dgr. Card":
				pass
			"Random Mrr. Card": 
				pass
			"Random Whl. Card": 
				pass
	elif item.type == Item.Type.CONSUMABLE:
		item_selected.emit(item)
	else:
		pass

func _on_options_button_focused(button: BaseButton) -> void:
	super(button)
	set_description(null)

func _on_options_button_pressed(button: BaseButton) -> void:
	state = button.get_index()
	match state:
		USE, REMOVE:
			if Data.player_inventory.empty():
				pass
			else:
				sub_menu.button_focus()
		SORT:
			Data.player_inventory.sort_items()
			update_item_buttons()
