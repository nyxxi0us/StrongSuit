extends TextureRect

var odd_frame: bool = false

func _on_timer_timeout() -> void:
	odd_frame = true if odd_frame == false else false
	if odd_frame:
		self.position.y -= 4
	else:
		self.position.y += 4
