class_name CardContainer extends MarginContainer

const CARD_COMPONENT_POSITION: Vector2 = Vector2(43,64)
@onready var functional_card_scn: PackedScene = preload("res://Scenes/Cards/card_functional.tscn")

var functional_card: Card_Functional

var card: CardData:
	set(_card):
		if !is_node_ready():
			await  ready
		card = _card
		functional_card = functional_card_scn.instantiate()
		add_child(functional_card)
		functional_card.set_position(CARD_COMPONENT_POSITION)
		functional_card.load_data(card)
