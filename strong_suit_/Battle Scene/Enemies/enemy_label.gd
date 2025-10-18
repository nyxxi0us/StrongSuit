class_name EnemyLabel extends HBoxContainer

var count: int = 0

@onready var _name: Label = $Name
@onready var _count: Label = $Count

func set_enemy_name(text: String) -> void:
	_name.text = text

func set_enemy_count(num: int) -> void:
	count = num
	_count.text = str(num)
	visible = num > 0

func get_enemy_count() -> int:
	return count

func get_enemy_name() -> String:
	return _name.text

func _on_EnemyButton_defeated() -> void:
	set_enemy_count(count-1)
