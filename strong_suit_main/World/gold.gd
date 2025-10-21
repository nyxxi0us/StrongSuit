class_name Gold extends Label

func _ready() -> void:
	Data.connect("player_gold_changed", on_data_player_gold_changed)
	set_gold(Data.player_gold)

func set_gold(n: int) -> void:
	text = str(n) + " GP"

func on_data_player_gold_changed(new_gold: int) -> void:
	set_gold(new_gold)
