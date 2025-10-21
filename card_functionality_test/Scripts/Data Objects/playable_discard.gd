class_name PlayableDiscard extends Resource

var cards: Array[CardWithID]

func draw_card() -> CardWithID:
	return cards.pop_back()

func shuffle() -> void:
	cards.shuffle()

func view_top() -> CardWithID:
	return cards.back()

func put_card_in(card: CardWithID, index: int = cards.size()-1) -> void:
	cards.insert(index,card)
