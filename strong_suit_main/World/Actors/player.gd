class_name Player extends Actor

signal moved(pos: Vector2, run_factor: float)

@onready var interaction_range: Area2D = $InteractionRange

func _enter_tree() -> void:
	GlobalScript.player = self

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and enabled:
		var colliders: Array = interaction_range.get_overlapping_bodies()
		var handled: bool = false
		for collider in colliders:
			if collider is NPC:
				collider.talk()
				handled = true
				break
		if !handled:
			colliders = interaction_range.get_overlapping_areas()
			for collider in colliders:
				if collider is InteractionRange:
					collider.interact_request()
					handled = true
					break
		else:
			return

func _process(_delta: float) -> void:
	var movement: Vector2 = Math.get_four_direction_vector(false)
	var run_mult: float = 2.0 if Input.is_action_pressed("Run") else 1.0
	if movement.is_equal_approx(Vector2.ZERO):
		sprite_sheet_animation.idle()
		return
	
	
	sprite_sheet_animation.set_speed_scale(run_mult)
	set_facing(movement, true)
	velocity = movement*SPEED*run_mult
	move_and_slide()
	moved.emit(position, run_mult)
