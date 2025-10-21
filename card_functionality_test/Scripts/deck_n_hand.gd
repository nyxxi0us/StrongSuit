class_name DeckHand extends Node2D

signal card_activate(card: Card_Functional)

const AETHER = preload("res://card_data/aether.tres")
const AIR = preload("res://card_data/air.tres")
const EARTH = preload("res://card_data/earth.tres")
const FIRE = preload("res://card_data/fire.tres")
const WATER = preload("res://card_data/water.tres")

const DECK_SIZE: int = 10
const CARD_SUITS: Array = [FIRE, AIR, AETHER, EARTH, WATER]

@onready var create_deck: Button = $CreateDeck
@onready var hand: Hand = $Hand

@export var deck: Deck
@export var debug_mode: bool = true:
	set(value):
		if !is_node_ready():
			await ready
		debug_mode = value
		if !debug_mode:
			create_deck.hide()
		else:
			create_deck.show()

func remove_card(card: Node) -> void:
	hand.remove_card_by_card(card.card)

func add_card(card_with_id: CardWithID) -> void:
	hand.add_card(card_with_id.card)

func reset() -> void:
	hand.empty_hand()

func _on_hand_card_activate(card: Card_Functional) -> void:
	card_activate.emit(card)

func _on_create_deck_pressed() -> void:
	if deck.get_cards().size() > 0:
		deck.clear_deck()
	for i in DECK_SIZE:
		deck.add_card(CARD_SUITS.pick_random().duplicate())
