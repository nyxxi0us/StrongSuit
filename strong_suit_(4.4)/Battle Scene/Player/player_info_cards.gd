class_name PlayerInfoCards extends NinePatchRect

@onready var _cards: Array = $MarginContainer/HBoxContainer/PlayerInfoContainer.get_children()

func _ready() -> void:
	for i in range(_cards.size()):
		var card: PlayerInfoCard = _cards[i]
		card.set_battle_actor(Data.party[i])
