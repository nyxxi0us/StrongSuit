class_name PlayableDeck extends Resource

var cards: Array[CardWithID]

func draw_card(handsize: int) -> Array[CardWithID]:
	var new_hamd: Array[CardWithID] = []
	for i in handsize:
		new_hamd.append(cards.pop_back())
	return new_hamd

func shuffle() -> void:
	cards.shuffle()

func view_top() -> CardWithID:
	return cards.back()

func put_card_in(card: CardWithID, index: int = cards.size()-1) -> void:
	cards.insert(index,card)
