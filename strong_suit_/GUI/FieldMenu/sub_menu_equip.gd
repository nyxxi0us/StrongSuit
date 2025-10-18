extends FieldSubMenu

enum {
	EQUIP,
	OPTIMAL,
	REMOVE
}

@onready var player_equipment_window: PlayerEquipmentWindow = $MarginContainer/PUT_MENU_HERE/Middle/MarginContainer/PlayerEquipmentWindow
@onready var equipped: Menu = player_equipment_window.get_equipment_menu()
@onready var inventory: Menu = $MarginContainer/PUT_MENU_HERE/Middle2/MarginContainer/HBoxContainer/ScrollContainer/Inventory
@onready var description_label: Label = $MarginContainer/PUT_MENU_HERE/Bottom/MarginContainer/DescriptionLabel
@onready var player_menu_card: PlayerMenuCard = player_equipment_window.get_player_menu_card()
@onready var stats_window: StatsWindow = $MarginContainer/PUT_MENU_HERE/Middle2/MarginContainer/HBoxContainer/StatsWindow

var state: int = -1
var current_slot: int = -1
var current_player: BattleActor = null

func _ready() -> void:
	super()
	set_sub_menu(equipped)
	set_sub_sub_menu(inventory)

func set_description(item: Item) -> void:
	description_label.text = item.desc

func _on_equipped_button_focused(button: BaseButton) -> void:
	sub_sub_menu.clear()
	stats_window.clear_target_values()
	pen_cursor.move_to_node(button)
	current_slot = button.get_index()
	var equipped_item: Item = current_player.cards[current_slot]
	if equipped_item:
		set_description(equipped_item)
	var player_items: Array = Data.player_inventory.get_items()
	for i in range(player_items.size()):
		var item: Item = player_items[i]
		if item.type == Item.Type.UPGRADE:
			if (equipped_item and equipped_item.name != item.name) or !equipped_item:
				sub_sub_menu.add_item_button(item)
	
	if state == REMOVE:
		var item: Item = Data.items.get(button.text)
		stats_window.set_target_item(item, current_slot, true)

func _on_equipped_button_pressed(button: BaseButton) -> void:
	if state == EQUIP:
		if sub_sub_menu.get_buttons_count() > 0:
			sub_sub_menu.button_focus()
		else:
			pass
	elif state == REMOVE:
		var item: Item = Data.items.get(button.text)
		if item:
			current_player.equip(null,current_slot)
			player_equipment_window.set_equipment()
			main_menu.button_focus()
		else:
			pass

func _on_inventory_button_focused(button: BaseButton) -> void:
	pen_cursor.move_to_node(button)
	var item: Item = Data.player_inventory.get_item_by_name(button.text)
	set_description(item)
	stats_window.set_target_item(item, current_slot)

func _on_inventory_button_pressed(button: BaseButton) -> void:
	var item: Item = Data.player_inventory.get_item_by_name(button.text)
	current_player.equip(item, current_slot)
	Data.player_inventory.remove_item(item,1)
	player_equipment_window.set_equipment()
	stats_window.set_target_item(null, current_slot)
	sub_menu.button_focus()

func _on_options_button_focused(button: BaseButton) -> void:
	super(button)
	description_label.text = ""
	stats_window.clear_target_values()
	player_equipment_window.update_current_player(Data.party_index)
	current_player = player_equipment_window.current_player
	stats_window.set_player(current_player)
	if current_player.cards.is_empty():
		var options_list: Array[Button] = options.get_buttons()
		var remove_button: Button = options_list[1]
		remove_button.disabled = true

func _on_options_button_pressed(button: BaseButton) -> void:
	state = button.get_index()
	match button.text.to_lower():
		"equip","remove":
			sub_menu.button_focus()
		"optimize":
			pass

func _on_player_changed(player: Variant) -> void:
	stats_window.set_player(player)
