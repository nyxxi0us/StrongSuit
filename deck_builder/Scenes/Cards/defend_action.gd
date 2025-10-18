class_name DefendAction extends RefCounted

func activate(game_state: Dictionary) ->void:
	var caster: Actor = game_state.get("caster")
	var card: Card = game_state.get("card").card
	
	caster.add_armor(card.suit_defense)
	caster.spend_energy(card.card_rank)
	
