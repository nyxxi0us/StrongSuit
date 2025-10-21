class_name EnemyButton extends BattleActorButton

@onready var _health: Label = $Health

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var enemy: int = -1

func _ready() -> void:
	set_process(false)
	animation_player.play("RESET")

func set_enemy(_enemy: BattleActor) -> void:
	if !_enemy:
		queue_free()
	else:
		show()
		set_data(_enemy.duplicate_custom())
		_health.text = str(data.hp_max)

func _on_data_hp_changed(hp: int, _change: int) -> void:
	_health.text = str(hp)
	if hp == 0:
		_health.modulate = Color.DARK_RED

func _process(_delta: float) -> void:
	self_modulate.a = randf()

func _on_data_defeated() -> void:
	await get_tree().create_timer(GlobalScript.DEFAULT_TIMER).timeout
	queue_free()

func _on_focus_entered() -> void:
	animation_player.play("Highlight")

func _on_focus_exited() -> void:
	animation_player.play("RESET")
