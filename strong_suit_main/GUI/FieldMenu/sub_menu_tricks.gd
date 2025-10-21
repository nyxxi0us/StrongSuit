extends FieldSubMenu

enum States {
	PREPARE,
	FORGET
}

var state: int = -1
var current_player: BattleActor = null
var spell_to_be_forgotten: Spell = null

@onready var spell_menu: Menu = $MarginContainer/PUT_MENU_HERE/Spells/MarginContainer/HBoxContainer/SpellMenu
@onready var description_label: Label = $MarginContainer/PUT_MENU_HERE/Description/MarginContainer/DescriptionLabel
@onready var player_menu_card: PlayerMenuCard = $MarginContainer/PUT_MENU_HERE/Player/MarginContainer/HBoxContainer/PlayerMenuCard
@onready var fm_cost: Label = $MarginContainer/PUT_MENU_HERE/Player/MarginContainer/HBoxContainer/FMCost
@onready var confirmation_window: Menu = $ConfirmationWindow

func _ready() -> void:
	super()
	set_sub_menu(spell_menu)
	set_sub_sub_menu(confirmation_window)

func update_labels(spell: Spell) -> void:
	description_label.text = spell.desc if spell else ""
	fm_cost.text = str(spell.cost) if spell else "0"

func prepare(spell_button: SpellButton) -> void:
	var spell: Spell = spell_button.spell
	if spell:
		if current_player.is_spell_prepared(spell):
			spell_button.icon.region.position.x = 6
		else:
			spell_button.icon.region.position.x = 0

func _on_options_button_focused(button: BaseButton) -> void:
	super(button)
	description_label.text = button.text
	fm_cost.text = "0"
	player_menu_card.set_player(Data.party[Data.party_index])
	sub_sub_menu.hide()

func _on_options_button_pressed(button: BaseButton) -> void:
	if !current_player.is_spells_empty():
		sub_menu.button_focus()
		if button.text == "Prepare":
			state = States.PREPARE
		else:
			state = States.FORGET

func _on_spellmenu_button_focused(button: SpellButton) -> void:
	var spell: Spell = button.spell
	pen_cursor.move_to_node(button)
	update_labels(spell)
	sub_sub_menu.hide()

func _on_spellmenu_button_pressed(button: SpellButton) -> void:
	var spell: Spell = button.spell
	match state:
		States.PREPARE:
			if spell:
				if current_player.is_spell_prepared(spell):
					current_player.unprepare_spell(spell)
				else:
					current_player.prepare_spell(spell)
				prepare(button)
			main_menu.button_focus()
		States.FORGET:
			sub_sub_menu.button_focus()
			pen_cursor.move_to_node(sub_sub_menu.get_buttons()[0])
			spell_to_be_forgotten = spell

func _on_confirmationwindow_button_focused(button: Button) -> void:
	sub_sub_menu.show()
	pen_cursor.move_to_node(button)

func _on_confirmationwindow_button_pressed(button: Button) -> void:
	if button.text == "Yes":
		if spell_to_be_forgotten:
			current_player.forget_spell(spell_to_be_forgotten)
			spell_to_be_forgotten = null
		main_menu.button_focus()
	else:
		spell_to_be_forgotten = null
		sub_menu.button_focus()
	sub_sub_menu.hide()

func _on_player_changed(player: BattleActor) -> void:
	if player != current_player:
		main_menu.button_focus()
		current_player = player
	for button in spell_menu.get_buttons():
		var spell: Spell = player.get_spell_at_index(button.get_index())
		button.set_spell(spell)
		prepare(button)
