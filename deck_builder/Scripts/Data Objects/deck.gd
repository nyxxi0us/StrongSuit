class_name Deck extends Resource
var card_collection: Dictionary = {}

var id_counter: int = 0

func add_card(card: CardData) -> void:
	var card_id: int = _generate_card_id(card)
	card_collection[card_id] = CardWithID.new(card_id,card)
	id_counter += 1

func clear_deck() -> void:
	if !get_cards().is_empty():
		for card in card_collection.values():
			remove_card(card.id)

func remove_card(card_id: int) -> void:
	if !get_cards().is_empty():
		card_collection.erase(card_id)

func update_card(card_id: int, card: CardData) -> void:
	card_collection[card_id] = card

func get_cards() -> Array:
	var cards: Array[CardWithID] = []
	if !card_collection.is_empty():
		for card in card_collection.values():
			var duplicate: CardWithID = CardWithID.new(card.id,card.card.duplicate())
			cards.push_back(duplicate)
	return cards

func get_playable_deck() -> PlayableDeck:
	var playable_deck: PlayableDeck = PlayableDeck.new()
	playable_deck.cards = get_cards()
	return playable_deck

func _generate_card_id(card: CardData):
	return id_counter
