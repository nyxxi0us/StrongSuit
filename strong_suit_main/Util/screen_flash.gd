class_name ScreenFlash extends ColorRect

@onready var _animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	play("RESET")

func play(anim_name: String) -> void:
	_animation_player.play(anim_name)

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()
