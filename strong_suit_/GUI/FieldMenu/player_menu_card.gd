class_name PlayerMenuCard extends Button

signal player_changed(player)

@onready var texture_rect: TextureRect = $HBoxContainer/TextureRect
@onready var status: Label = $HBoxContainer/HFlowContainer/HBoxContainer/Status
@onready var level: Label = $HBoxContainer/HFlowContainer/HBoxContainer/Level
@onready var _class: Label = $HBoxContainer/HFlowContainer/HBoxContainer/Class
@onready var hp: Label = $HBoxContainer/HFlowContainer/HBoxContainer2/HP
@onready var fame: Label = $HBoxContainer/HFlowContainer/HBoxContainer3/Fame


var player: BattleActor = null
var freeze: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if get_parent().is_visible_in_tree() and !freeze:
		var direction: int = 0
		if event.is_action_pressed("left_shoulder"):
			direction = -1
		elif event.is_action_pressed("right_shoulder"):
			direction = 1
		Data.party_index = wrapi(Data.party_index + direction, 0, Data.party.size())
		set_player(Data.party[Data.party_index])

func set_player(_player: BattleActor) -> void:
	if player:
		player.disconnect("on_hp_changed", _on_Player_hp_changed)
		player.disconnect("on_fm_changed", _on_Player_fm_changed)
	
	player = _player
	player.connect("on_hp_changed", _on_Player_hp_changed)
	player.connect("on_fm_changed", _on_Player_fm_changed)
	
	if player:
		if player.texture:
			texture_rect.texture = player.texture
		status.hide()
		level.text = str(player.level)
		_class.text = player.name
		hp.text = str(player.hp) + "/" + str(player.hp_max)
		fame.text = str(player.fm) + "/" + str(player.fm_max)
		player_changed.emit(player)
	else:
		hide()

func _on_Player_hp_changed(_hp: int, _change: int) -> void:
	hp.text = str(_hp) + "/" + str(player.hp_max)

func _on_Player_fm_changed(_fm: int, _change: int) -> void:
	fame.text = str(_fm) + "/" + str(player.fm_max)
