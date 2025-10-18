class_name PlayerEquipmentWindow extends HBoxContainer

signal equipped_button_focused(button)
signal equipped_button_pressed(button)
signal player_changed(player)

enum Icons {
	NOTCH,
	SLEEVE,
	FOIL
}

@onready var equipped: Menu = $VBoxContainer2/HBoxContainer/Equipped
@onready var player_menu_card: PlayerMenuCard = $PlayerMenuCard

var current_player: BattleActor = null

func _ready() -> void:
	equipped.connect_to_buttons(self)

func get_equipment_menu() -> Menu:
	return equipped

func get_player_menu_card() -> PlayerMenuCard:
	return player_menu_card

func set_equipment() -> void:
	var equipment_buttons: Array = equipped.get_buttons()
	for i in range(equipment_buttons.size()):
		var equipment: Item = current_player.cards[i]
		var button: Button = equipment_buttons[i]
		if equipment:
			button.text = equipment.name
			var icon_index: int = 8*Icons[equipment.name.to_upper()]
			button.icon.region.position.x = icon_index
		else: 
			button.text = "--"
			button.icon.region.position.x = -8

func _on_equipped_button_focused(button: BaseButton) -> void:
	equipped_button_focused.emit(button)

func _on_equipped_button_pressed(button: BaseButton) -> void:
	equipped_button_pressed.emit(button)

func _on_player_changed(player: Variant) -> void:
	current_player = player
	set_equipment()
	player_changed.emit(player)

func update_current_player(index: int) -> void:
	player_menu_card.set_player(Data.party[index])
