class_name CardWithID extends Resource

var id: int
var card: CardData

func _init(_id: int, _card: CardData) -> void:
	card = _card
	id = _id
