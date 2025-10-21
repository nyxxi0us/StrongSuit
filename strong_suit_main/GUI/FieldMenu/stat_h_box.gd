class_name StatHBox extends Button

@onready var value: Label = $Value

func set_stat(player: BattleActor) -> void:
	var stat_to_change: String = text
	match stat_to_change:
		"SPEED":
			value.text = str(player.speed)
		"POWER":
			value.text = str(player.power)
		"DEFENSE":
			value.text = str(player.defense)
		"ACCURACY":
			value.text = str(player.accuracy)
		"ATTACK":
			value.text = str(player.attack)
		"STAMINA":
			value.text = str(player.stamina)
		"INTELLECT":
			value.text = str(player.intellect)
		"FAME":
			value.text = str(player.fm)
	
