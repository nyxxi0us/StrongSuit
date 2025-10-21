class_name Card_Functional extends Node2D
signal mouse_entered(card: Card)
signal mouse_exited(card: Card)

var actions: Array[RefCounted] = []
var data: CardData
@onready var card: Card = $Card

func load_data(_data: CardData) -> void:
	data = _data
	card.set_card_values(data.card_suit,data.card_rank)
	for script in data.actions:
		var action_node = RefCounted.new()
		action_node.set_script(script)
		actions.push_back(action_node)

func _on_card_mouse_entered(_card: Card) -> void:
	mouse_entered.emit(self)

func _on_card_mouse_exited(_card: Card) -> void:
	mouse_exited.emit(self)

func highlight(on: bool) -> void:
	card.highlight(on)

func activate(game_state: Dictionary) -> void:
	for action in actions:
		action.activate(game_state)

func get_cost() -> int:
	return card.card_rank
