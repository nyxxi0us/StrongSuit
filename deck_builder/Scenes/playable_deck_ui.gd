class_name PlayableDeckUI extends TextureButton

var deck: PlayableDeck

func draw(hand_size: int) -> Array[CardWithID]:
	return deck.draw_card(hand_size)
