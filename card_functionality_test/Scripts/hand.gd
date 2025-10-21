class_name Hand extends Node2D

signal card_activate(card: Card_Functional)

@export var hand_radius: int = 100
@export var card_angle: float = 90
@export var angle_limit: float = 20
@export var max_spread_angle: float = 5

@onready var functional_card_scn: PackedScene = preload("res://Scenes/Cards/card_functional.tscn")

var in_hand: Array = []
var highlight_index: int = -1
var hovered_cards: Array = []

func _process(_delta: float) -> void:
	for card in in_hand:
		if card:
			card.highlight(false)
	highlight_index = -1
	if !hovered_cards.is_empty():
		var top_hovered_index: int = -1
		for hovered_card in hovered_cards:
			top_hovered_index = max(top_hovered_index, in_hand.find(hovered_card))
		if top_hovered_index >= 0 and top_hovered_index < in_hand.size():
			if in_hand[top_hovered_index]:
				in_hand[top_hovered_index].highlight(true)
				highlight_index = top_hovered_index

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_click") and highlight_index >= 0:
		var card = in_hand[highlight_index]
		card_activate.emit(card)
		highlight_index = -1

func add_card(data: CardData) -> void:
	var functional_card = functional_card_scn.instantiate()
	in_hand.push_back(functional_card)
	add_child(functional_card)
	functional_card.load_data(data)
	functional_card.mouse_entered.connect(_handle_card_hover)
	functional_card.mouse_exited.connect(_handle_card_unhovered)
	reposition_cards()

func reposition_cards() -> void:
	var card_spread = min(angle_limit / in_hand.size(), max_spread_angle)
	var current_angle = -(card_spread * (in_hand.size()-1))/2 -90
	for card in in_hand:
		if card:
			_card_transform_update(card, current_angle)
			current_angle += card_spread

func remove_card_by_index(index: int) -> Card_Functional:
	if in_hand[index]:
		var removing_card: Node = in_hand.pop_at(index)
		hovered_cards.remove_at(index)
		remove_child(removing_card)
		reposition_cards()
		return removing_card
	else:
		return null

func remove_card_by_card(card: Card) -> Card_Functional:
	var remove_index: int = in_hand.find(card)
	return remove_card_by_index(remove_index)

func empty_hand() -> void:
	highlight_index = -1
	for card in in_hand:
		if card:
			card.queue_free()
	in_hand = []
	hovered_cards = []

func get_card_position(card: Card_Functional, angle_deg: float) -> Vector2:
	var highlight_raise: int = 0
	if hovered_cards:
		if hovered_cards.front() == card:
			highlight_raise = 30
	var x: float = (hand_radius + highlight_raise) * cos(deg_to_rad(angle_deg))
	var y: float = (hand_radius + highlight_raise) * sin(deg_to_rad(angle_deg))
	return Vector2(x,y)

func _card_transform_update(card: Card_Functional, angle_in_drag: float) ->void:
	card.set_position(get_card_position(card,angle_in_drag))
	card.set_rotation(deg_to_rad(angle_in_drag+90))

func _handle_card_hover(card: Card_Functional) -> void:
	hovered_cards.push_back(card)
	reposition_cards()

func _handle_card_unhovered(card: Card_Functional) -> void:
	hovered_cards.remove_at(hovered_cards.find(card))
	reposition_cards()
