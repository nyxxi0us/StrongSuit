class_name DeckWindow extends ScrollContainer

@onready var card_container_scn: PackedScene = preload("res://Scenes/card_container.tscn")
@onready var flow_container: HFlowContainer = $FlowContainer

var cached_card_containers: Array[CardContainer] = []
func clear_display() -> void:
	for child in flow_container.get_children():
		child.remove_child(child.functional_card)
		flow_container.remove_child(child)

func display_card_list(cards_with_id: Array[CardWithID]):
	clear_display()
	while cached_card_containers.size() < cards_with_id.size():
		cached_card_containers.push_back(card_container_scn.instantiate() as CardContainer)
	
	for i in cards_with_id.size():
		var card_with_id: CardWithID = cards_with_id[i] as CardWithID
		var card_container: CardContainer = cached_card_containers[i]
		flow_container.add_child(card_container)
		card_container.card = card_with_id.card
