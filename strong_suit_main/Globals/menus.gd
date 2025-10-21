extends Node

var levels: Array = []

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if levels:
			levels.pop_back()

func clear() -> void:
	levels.clear()

func _on_menu_activated(menu: Menu) ->void:
	if !levels.has(menu):
		levels.append(menu)
