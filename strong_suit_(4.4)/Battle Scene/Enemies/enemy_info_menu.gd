class_name EnemyInfoMenu extends NinePatchRect

@onready var _info_boxes: Array = $MarginContainer/EnemyInfoContainer.get_children()

func _ready() -> void:
	for i in range(_info_boxes.size()):
		_info_boxes[i].hide()

func add_enemy(enemy: BattleActor, _enemy_button: EnemyButton)-> void:
	for i in range(_info_boxes.size()):
		var info_box: EnemyLabel = _info_boxes[i]
		if info_box.visible:
			if info_box.get_enemy_name() == enemy.name:
				info_box.set_enemy_count(info_box.count+1)
				return
		else:
			info_box.set_enemy_name(enemy.name)
			info_box.set_enemy_count(1)
			enemy.defeated.connect(info_box._on_EnemyButton_defeated)
			return
