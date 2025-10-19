class_name FieldMenu extends FullScreenGUI

enum SubMenus {
	ITEMS,
	MAGIC,
	EQUIP,
	STATUS,
	FORM,
	CONFIG,
	SAVE
}

@onready var options: Menu = $MarginContainer/PUT_MENU_HERE/HBoxContainer/VBoxContainer/Options
@onready var player_menu_cards: Menu = $MarginContainer/PUT_MENU_HERE/HBoxContainer/Party/MarginContainer/PlayerMenuCards
@onready var sub_menus: Array = $SubMenus.get_children()
@onready var gold: Label = $MarginContainer/PUT_MENU_HERE/HBoxContainer/VBoxContainer/Info/MarginContainer/VBoxContainer/Gold
@onready var area: Label = $MarginContainer/PUT_MENU_HERE/HBoxContainer/VBoxContainer/Info2/MarginContainer/VBoxContainer/Area

var selected_item: Item = null
var selected_player: PlayerMenuCard = null
var in_form_mode: bool = false
var blinking_cursor: Cursor = null

func _ready() -> void:
	set_main_menu(options)
	set_sub_menu(player_menu_cards)
	enable(false)
	
	for player_menu_card in player_menu_cards.get_buttons():
		player_menu_card.freeze = true
		player_menu_card.set_player(Data.party[player_menu_card.get_index()])

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Menu"):
		enable(!enabled)
	else:
		return

func _on_options_button_pressed(button: BaseButton) -> void:
	var index: int = button.get_index()
	if index == SubMenus.FORM:
		in_form_mode = true
		sub_menu.button_focus()
	else:
		in_form_mode = false
		if index<sub_menus.size():
			sub_menus[index].enable(true)

func _on_playermenucards_button_pressed(button: PlayerMenuCard) -> void:
	if selected_item:
		var player: BattleActor = button.player
		player.healhurt(int(selected_item.attribute))
		Data.player_inventory.remove_item(selected_item, 1)
		selected_item = null
		sub_menus[SubMenus.ITEMS].return_from_item_use()
	elif in_form_mode:
		if selected_player and selected_player != button:
			var player_a: BattleActor = selected_player.player
			var player_b: BattleActor = button.player
			Data.players[selected_player.get_index()] = player_b
			Data.players[button.get_index()] = player_a
			print(Data.players.size())
			button.set_player(player_a)
			selected_player.set_player(player_b)
			selected_player = null
			blinking_cursor.queue_free()
		else:
			selected_player = button
			if blinking_cursor:
				blinking_cursor.queue_free()
			blinking_cursor = CURSOR.instantiate()
			add_child(blinking_cursor)
			blinking_cursor.move_to_node(selected_player)
			blinking_cursor.set_blink(true)

func _on_playermenucards_button_focused(button: PlayerMenuCard) -> void:
	pen_cursor.move_to_node(button)
	
	if in_form_mode and selected_player:
		pen_cursor.set_blink(button == selected_player)

func _on_sub_menu_items_item_selected(item: Item) -> void:
	selected_item = item
	sub_menus[SubMenus.ITEMS].hide()
	sub_menu.button_focus()

func _on_sub_menu_closing(_GUI: FullScreenGUI) -> void:
	enable(true)
	if is_node_ready():
		main_menu.button_focus()
