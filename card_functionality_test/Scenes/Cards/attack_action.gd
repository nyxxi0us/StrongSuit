class_name AttackAction extends RefCounted

func activate(game_state: Dictionary) ->void:
	var caster: Actor = game_state.get("caster")
	var target: Actor = game_state.get("targets")[0]
	var card: Card = game_state.get("card").card
	
	caster.spend_energy(card.suit_damage)
	target.healhurt(-card.card_rank)
