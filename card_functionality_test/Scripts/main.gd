class_name Main extends Node2D

const HAND_SIZE = 10

@onready var player_actor: Actor = $GameScreen/PlayerActor
@onready var enemy_actor: Actor = $GameScreen/EnemyActor
@onready var energy: Label = $VBoxContainer/Energy
@onready var game_controller: GameController = $GameController
@onready var deck_n_hand: DeckHand = $DeckNHand
@onready var defeat_color: ColorRect = $CanvasLayer/DefeatColor
@onready var victory_color: ColorRect = $CanvasLayer/VictoryColor
@onready var deck_window: DeckWindow = $CanvasLayer/DeckWindow
@onready var damage_1: Button = $"VBoxContainer/Damage 1"
@onready var damage_3: Button = $"VBoxContainer/Damage 3"
@onready var deck_ui: PlayableDeckUI = $VBoxContainer/PlayableDeckUi
@onready var discard_window: DiscardWindow = $CanvasLayer/DiscardWindow

@onready var deck: Deck = Deck.new()
@onready var discard: Discard = Discard.new()
#@onready var debug_nodes: Array[Node] = get_tree().get_nodes_in_group("debug")

@export var debug_mode: bool = true:
	set(value):
		if !is_node_ready():
			await ready
		debug_mode = value
		deck_n_hand.debug_mode = debug_mode
		if !debug_mode:
			damage_1.hide()
			damage_3.hide()
		else:
			damage_1.show()
			damage_3.show()


var enemy_current_state: int = 0
var enemy_turn = GameController.GameState.ENEMY_TURN
var player_turn = GameController.GameState.PLAYER_TURN
var defeat = GameController.GameState.DEFEAT
var victory = GameController.GameState.VICTORY
var paused = GameController.GameState.PAUSE

func _ready() -> void:
	defeat_color.hide()
	victory_color.hide()
	deck_window.hide()
	deck_ui.hide()
	deck_n_hand.deck = deck

func restart_game() -> void:
	game_controller.current_state = player_turn
	player_actor.reset()
	enemy_actor.reset()
	deck_n_hand.reset()
	deck_ui.deck = deck.get_playable_deck()
	deck_ui.show()
	draw_hand()

func _process(_delta: float) -> void:
	if game_controller.current_state == paused:
		if deck_window.is_visible_in_tree():
			deck_window.display_card_list(deck.get_cards())
	
	var player_energy = player_actor.energy
	if energy.text != str(player_energy):
		energy.text = str(player_energy)
	if player_actor.hp <= 0:
		game_controller.current_state = defeat
	elif enemy_actor.hp <= 0:
		game_controller.current_state = victory
	match game_controller.current_state:
		enemy_turn:
			defeat_color.hide()
			victory_color.hide()
			enemy_actor.add_armor(enemy_current_state)
			player_actor.healhurt(-(3-enemy_current_state))
			enemy_current_state = posmod(enemy_current_state + 1, 3)
			game_controller.transition(player_turn)
			draw_hand()
			player_actor.start_turn()
		victory:
			victory_color.show()
		defeat:
			defeat_color.show()
		_:
			defeat_color.hide()
			victory_color.hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		restart_game()

func _on_deck_n_hand_card_activate(card: Card_Functional) -> void:
	var card_cost = card.get_cost()
	if card_cost > player_actor.energy:
		for i in 5:
			card.modulate = Color.RED
			await get_tree().process_frame
			card.modulate = Color.WHITE
		return
	else:
		card.activate({
			"card": card,
			"caster": player_actor,
			"targets": [enemy_actor]
		})
		deck_n_hand.remove_card(card)
		discard.add_card(card.data)
		card.queue_free()

func draw_hand() -> void:
	if pla< HAND_SIZE:
		print(deck.card_collection.size())
		if discard.discard_pile.size() >= HAND_SIZE:
			for card_with_id in discard.discard_pile:
				deck.add_card(card_with_id.card)
	var cards_with_id: Array[CardWithID] = deck_ui.draw(HAND_SIZE)
	if !cards_with_id.is_empty():
		for card_with_id in cards_with_id:
			if card_with_id:
				deck_n_hand.add_card(card_with_id)

func _on_end_turn_pressed() -> void:
	if game_controller.current_state == player_turn:
		game_controller.transition(enemy_turn)
		deck_n_hand.reset()
		enemy_actor.start_turn()

func _on_start_button_pressed() -> void:
	restart_game()

func _on_playable_deck_ui_pressed() -> void:
	if game_controller.current_state == paused:
		deck_window.hide()
		game_controller.resume()
	else:
		game_controller.pause()
		deck_window.show()
		deck_window.display_card_list(deck.get_cards())

func _on_playable_discard_pressed() -> void:
	if game_controller.current_state == paused:
		discard_window.hide()
		game_controller.resume()
	else:
		game_controller.pause()
		discard_window.show()
		discard_window.display_card_list(discard.get_cards())
