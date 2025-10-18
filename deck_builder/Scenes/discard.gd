class_name Discard extends Resource

var discard_pile: Dictionary = {}

var id_counter: int = 0

func add_card(card: CardData) -> void:
	var card_id: int = _generate_card_id(card)
	discard_pile[card_id] = CardWithID.new(card_id,card)
	id_counter += 1

func clear_pile() -> void:
	if !get_cards().is_empty():
		for card in discard_pile.values():
			remove_card(card.id)

func remove_card(card_id: int) -> void:
	if !get_cards().is_empty():
		discard_pile.erase(card_id)

func update_card(card_id: int, card: CardData) -> void:
	discard_pile[card_id] = card

func get_cards() -> Array:
	var cards: Array[CardWithID] = []
	if !discard_pile.is_empty():
		for card in discard_pile.values():
			var duplicate: CardWithID = CardWithID.new(card.id,card.card.duplicate())
			cards.push_back(duplicate)
	return cards

func get_playable_discard() -> PlayableDiscard:
	var playable_discard: PlayableDiscard = PlayableDiscard.new()
	playable_discard.cards = get_cards()
	return playable_discard

func _generate_card_id(card: CardData):
	return id_counter
