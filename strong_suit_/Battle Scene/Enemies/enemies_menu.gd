class_name EnemiesMenu extends Menu

func create_enemies(enemies: Array) -> void:
	for i in range(enemies.size()):
		var this_enemy: BattleActor = enemies[i]
		get_buttons()[i].enemy = this_enemy
