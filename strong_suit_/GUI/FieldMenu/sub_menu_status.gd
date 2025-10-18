extends FieldSubMenu

@onready var stats: Menu = $MarginContainer/PUT_MENU_HERE/Middle/MarginContainer/VBoxContainer/Stats
@onready var description_label: Label = $MarginContainer/PUT_MENU_HERE/Description/MarginContainer/DescriptionLabel
@onready var player_equipment_window: PlayerEquipmentWindow = $MarginContainer/PUT_MENU_HERE/Middle/MarginContainer/VBoxContainer/HBoxContainer/PlayerEquipmentWindow

var stat_desc_list: Dictionary = {
	"SPEED": "Who goes first in combat",
	"POWER": "How strong your cards are",
	"DEFENSE": "How hard you are to hit",
	"ACCURACY": "How likely you are to hit",
	"ATTACK": "How damaging your hits are",
	"STAMINA": "How healthy you are",
	"INTELLECT": "How well your special works",
	"FAME": "How often you can use your special"
}


var current_player: BattleActor = null

func _ready() -> void:
	super()
	set_main_menu(stats)
	for button in stats.get_buttons():
		button.text = stat_desc_list.keys()[button.get_index()-1]


func _on_stats_button_focused(button: StatHBox) -> void:
	pen_cursor.move_to_node(button)
	var stat_desc: String = stat_desc_list[button.text]
	description_label.text = stat_desc
		
	player_equipment_window.update_current_player(Data.party_index)
	current_player = player_equipment_window.current_player
	player_equipment_window.set_equipment()

func _on_player_changed(player: Variant) -> void:
	for stathbox in stats.get_buttons():
		stathbox.set_stat(player)
