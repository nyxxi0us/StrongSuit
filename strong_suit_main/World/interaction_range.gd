class_name InteractionRange extends Area2D

signal  interact_requested()

func interact_request() -> void:
	interact_requested.emit()
