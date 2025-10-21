class_name StatsWindow extends HBoxContainer

enum {
	POWER,
	DEFENSE,
	SPEED,
	LENGTH
}

var player: BattleActor = null

@onready var old_values: Array = $HBoxContainer/OldValues.get_children()
@onready var arrows: Array = $HBoxContainer/Arrows.get_children()
@onready var new_values: Array = $HBoxContainer/NewValues.get_children()

func _ready() -> void:
	clear_target_values()

func clear_target_values() -> void:
	for i in range(LENGTH):
		new_values[i].text = ""

func set_player(_player: BattleActor) -> void:
	if player:
		player.disconnect("equipment_changed", on_Player_equipment_changed)
	
	player = _player
	player.connect("equipment_changed", on_Player_equipment_changed)
	set_old_values()
	

func set_old_values() -> void:
	await get_tree().process_frame 
	old_values[SPEED].text = str(player.speed)
	old_values[POWER].text = str(player.power)
	old_values[DEFENSE].text = str(player.defense)

func set_target_item(target_item: Item, slot: int, subtract: bool = false) -> void:
	clear_target_values()
	
	if target_item:
		var stat_type: int = target_item.stat
		var base_stat: float = 0
		var current_item: Item = player.get_equipment_at_slot(slot)
		#var current_item_stat_type: int = current_item.stat if current_item else 0
		
		if !subtract and current_item:
			base_stat -= current_item.attribute
		
		match target_item.stat:
			Item.Stats.DEFENSE:
				base_stat += player.defense
			Item.Stats.POWER:
				base_stat += player.power
			Item.Stats.SPEED:
				base_stat += player.speed
		
		var target_value: float = base_stat
		if subtract:
			target_value -= target_item.attribute 
			
		else:
			target_value += target_item.attribute
		
		var new_value_label: Label = new_values[stat_type]
		new_value_label.text = str(target_value)
		
		if target_value < base_stat:
			new_value_label.modulate = Color.RED
		elif target_value > base_stat:
			new_value_label.modulate = Color.GREEN
		else:
			new_value_label.modulate = Color.WHITE

func on_Player_equipment_changed() -> void:
	set_old_values()
