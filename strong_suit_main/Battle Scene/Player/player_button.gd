class_name PlayerButton extends BattleActorButton

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	set_data(Data.party[get_index()])
	animation_player.play("RESET")

func _on_data_defeated() -> void:
	await get_tree().create_timer(GlobalScript.DEFAULT_TIMER).timeout
	self_modulate = Color.BLACK

func _on_focus_entered() -> void:
	animation_player.play("Highlight")

func _on_focus_exited() -> void:
	animation_player.play("RESET")
