class_name PlayerInfoCard extends Control

@onready var data: BattleActor = null
@onready var _name: Label = $MarginContainer/Text/Name
@onready var _health: Label = $MarginContainer/Text/Health
@onready var _mana: Label = $MarginContainer/Text/Mana
@onready var _level: Label = $MarginContainer/Text/Level
@onready var _text: Array = $MarginContainer/Text.get_children()
@onready var _tween: Tween 
@onready var _start_y: float = 106
@onready var _highlight_y: float = 102

func _ready() -> void:
	visible = data != null

func highlight(on: bool) -> void:
	var target_y: float = _highlight_y if on else _start_y
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(self, "global_position:y", target_y, 0.125).set_trans(Tween.TRANS_CIRC)

func set_battle_actor(actor: BattleActor) -> void:
	if actor:
		data = actor
		show()
		_name.text = data.name.left(4-data.name.length())
		_health.text = str(data.hp_max)
		_mana.text = str(data.mp_max)
		_level.text = str(data.level)
		data.hp_changed.connect(_on_data_hp_changed)
		data.mp_changed.connect(_on_data_mp_changed)
	else:
		hide()

func _on_data_hp_changed(hp: int, _change: int) -> void:
	_health.text = str(hp)
	if hp == 0:
		for node in _text:
			node.modulate = Color.DARK_RED

func _on_data_mp_changed(mp: int, _change: int) -> void:
	_mana.text = str(mp)
	if mp == 0:
		_mana.modulate = Color.DARK_BLUE
