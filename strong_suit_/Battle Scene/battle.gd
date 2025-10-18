class_name Battle extends Control

enum Action {
	HIT,
	TRICK,
	STAND,
	FOLD
}

enum {
	ACTOR,
	ACTION,
	TARGET
}

enum Trick {
	A,
	B,
	C,
	D
}

enum State {
	VICTORY,
	DEFEAT
}

const EXIT_DURATION: float = 0.5

@export var auto_advance_text: bool = false
@export var call_stand_immediately: bool = false

var enemies_weighted: Array = []
var event_queue: Array = []
var text_queue: Array = []
var enemy_actions: Array = [Action.HIT, Action.STAND]

var current_party_index: int = -1
var current_action:      int = -1
var current_trick:       int = -1
var current_target:      BattleActor = null
var xp_gained:           int = -1
var gold_gained:         int = -1
var current_state:       int = -1
var party_size:          int = Data.party.size()

@onready var _players_menu: Menu = $Background/MarginContainer/VBoxContainer/Battlefield/PlayersMenu
@onready var _enemies_menu: Menu = $Background/MarginContainer/VBoxContainer/Battlefield/EnemiesMenu
@onready var _player_info_cards: Array = get_tree().get_nodes_in_group("player_cards")
@onready var _enemy_info_menu: EnemyInfoMenu = $Background/MarginContainer/VBoxContainer/InfoOptions/EnemyInfoMenu
@onready var _option_menu: Menu = $Background/MarginContainer/VBoxContainer/InfoOptions/OptionMenu
@onready var _trick_menu: Menu = $Background/MarginContainer/VBoxContainer/InfoOptions/TrickMenu
@onready var _info_options: Control = $Background/MarginContainer/VBoxContainer/InfoOptions
@onready var _background: MarginContainer = $Background/MarginContainer
@onready var dialogue_box: DialogueBox = $DialogueBox
@onready var _screenshake: ScreenShake = $Camera2D/Screenshake

func _ready() -> void:
	$Camera2D.make_current()
	dialogue_box.clear()
	_option_menu.show()
	_option_menu.button_focus()
	_option_menu.connect_to_buttons(self)
	_trick_menu.connect_to_buttons(self)
	
	var data: BattleActor = null
	for player_button in _players_menu.get_buttons():
		data = player_button.data
		player_button.pressed.connect(_on_battle_actor_pressed.bind(player_button))
		player_button.data.defeated.connect(_on_battle_actor_defeated.bind(data))
		player_button.data.hp_changed.connect(_on_player_hp_changed)
	
	var enemy_total: int = 0
	for enemy_button in _enemies_menu.get_buttons():
		var spawn_chance: float = 1.0 - (enemy_total * 0.2)
		if randf() > spawn_chance:
			enemy_button.queue_free()
			continue
		var enemy_weights: Array = []
		var potential_enemies: Array = []
		for i in enemies_weighted.size():
			if i % 2 == 0:
				enemy_weights.append(enemies_weighted[i])
			else:
				potential_enemies.append(enemies_weighted[i])
		var enemy_name: String = Util.choose_weighted(potential_enemies, enemy_weights)
		enemy_button.set_enemy(Data.enemies[enemy_name])
		data = enemy_button.data
		if data:
			_enemy_info_menu.add_enemy(data, enemy_button)
			enemy_button.pressed.connect(_on_battle_actor_pressed.bind(enemy_button))
			enemy_button.data.defeated.connect(_on_battle_actor_defeated.bind(data))
			enemy_total += 1

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if _option_menu.menu_is_focused():
			if event_queue.size() > 0:
				event_queue.pop_back()
				goto_next_player(-1)
			else:
				print("Incorrect buzzer")
		elif _enemies_menu.menu_is_focused():
			_option_menu.button_focus()
	else:
		return

func sort_events_by_speed(a,b) -> bool:
	var actor1: BattleActor = a[ACTOR]
	var actor2: BattleActor = b[ACTOR]
	var speed1: int = actor1.speed_roll() if actor1 else 0
	var speed2: int = actor2.speed_roll() if actor2 else 0
	return speed1 > speed2

func sort_stands_to_top(a,b) -> bool:
	if a[ACTION] == Action.STAND:
		if b[ACTION] == Action.STAND:
			return sort_events_by_speed(a,b)
		else:
			return true
	else:
		return false

func sort_events() -> void:
	event_queue.sort_custom(sort_events_by_speed)
	if !call_stand_immediately:
		event_queue.sort_custom(sort_stands_to_top)
	else:
		pass
	#if !run_action.empty():
		#event_queue.push_front(run_action.duplicate())
		#run_action.clear()

func goto_next_player(dir: int = 1) -> void:
	if !is_equal_approx(abs(dir), 1.0):
		print("goto_next_player dir must be 1 or -1")
		return 
	_player_info_cards[current_party_index].highlight(false)
	
	while current_party_index >= -1 and current_party_index + dir < party_size:
		current_party_index += dir
		var player: BattleActor = Data.party[current_party_index]
		if player.hp > 0:
			_player_info_cards[current_party_index].highlight(true)
			_option_menu.button_focus()
			return
	
	if dir != 1: 
		return
	
	current_party_index = -1
	
	for enemy_button in _enemies_menu.get_buttons():
		var enemy: BattleActor = enemy_button.data
		var action: int = Util.choose_weighted([Action.HIT,Action.STAND],[4,1])
		var target: BattleActor = enemy if action == Action.STAND else Util.choose(Data.party)
		add_event(enemy,action,target)
	
	sort_events()
	advance_event_queue()


func debug_reload() -> void:
	_background.hide()
	await get_tree().create_timer(1).timeout
	dialogue_box.add_text(["DEBUG: Reloading current scene..."])
	await dialogue_box.closed
	get_tree().reload_current_scene()

func animate_options(node: Control, enter: bool) -> void:
	var target_y: float = 104 if enter else 180
	var target_alpha: float = 1.0 if enter else 0.0

	var _tween: Tween = get_tree().create_tween()
	_tween.tween_property(node, "global_position:y", target_y , EXIT_DURATION)
	_tween.parallel().tween_property(node, "modulate:a", target_alpha, EXIT_DURATION)

func add_event(actor: BattleActor, action: int, target: BattleActor) -> void:
	event_queue.append([actor,action,target])

func add_player_event(_action: int, _target: BattleActor = Data.party[current_party_index]) -> void:
	add_event(Data.party[current_party_index], _action, _target)
	goto_next_player(1)

func run_event(actor: BattleActor, action: int, target: BattleActor) -> void:
	if !actor:
		return

	if actor.hp <= 0:
		await get_tree().create_timer(0.25).timeout
		return
	
	var party_member: bool = target.friendly
	
	if target.hp <= 0:
		var targets: Array = Data.party.duplicate() if party_member else Data.enemy_list.duplicate()
		target = null
		targets.shuffle()
		
		for potential_target in targets:
			if potential_target.hp > 0:
				target = potential_target
				break
		if !target:
			action = -1
			
	
	var text: Array = []
	
	match action:
		Action.HIT:
			var attack: int = actor.damage_roll()
			if attack < 0:
				target.healhurt(attack)
				text = ["The " + actor.name + " hits the " + target.name + " and deals " + str(-attack) + " damage!"]
			else:
				text = ["The " + actor.name + " missed the " + target.name + "..."]
			if target.hp <= 0:
				target = null
		Action.TRICK:
			match actor.name:
				"Bastard":
					text = ["The Bastard used his trick: Rain of Arrows!"]
				"Ronin":
					text = ["The Ronin used his trick: Deflect Attack!"]
				"Mercenary":
					text = ["The Mecenary used his trick: Tactical Libation!"]
				"Stowaway":
					text = ["The Stowaway used his trick: Cut to Ribbons!"]
		Action.STAND:
			actor.is_standing = true
			text = ["The " + actor.name + " stands ready!"]
		Action.FOLD:
			text = ["The " + actor.name + " folds and forfeits the turn!"]
		_:
			print("No Action")
	
	if text.size() > 0:
		dialogue_box.add_text(text)
		if auto_advance_text:
			for i in range(text.size()):
				await get_tree().create_timer(0.5).timeout
				dialogue_box.advance()
		else:
			await dialogue_box.closed
	if !target:
		var targets: Array = Data.party if party_member else Data.enemy_list
		current_state = State.DEFEAT if party_member else State.VICTORY
		for potential_target in targets:
			if potential_target.hp > 0:
				current_state = -1
				break
		if current_state in [State.VICTORY, State.DEFEAT]:
			event_queue.clear()
			await get_tree().create_timer(0.25).timeout
			return

func advance_event_queue() -> void:
	for i in range(event_queue.size()):
		if event_queue.is_empty():
			break
		var event: Array = event_queue[i]
		run_event(event[ACTOR], event[ACTION], event[TARGET])
	
	for enemy_button in _enemies_menu.get_buttons():
		enemy_button.data.is_standing = false
	
	for player_button in _players_menu.get_buttons():
		player_button.data.is_standing = false
	
	match current_state:
		State.VICTORY:
			print("Defeat")
			var text: Array = [
				"Every member gains " + str(xp_gained) + " xp!",
				"The party also finds " + str(gold_gained) + " gold!"
			]
			for player in Data.party:
				player.xp += xp_gained
				player.gold += gold_gained
			
			if text.size() > 0:
				dialogue_box.add_text(text)
				if auto_advance_text:
					for i in range(text.size()):
						await get_tree().create_timer(0.5).timeout
						dialogue_box.advance()
				else:
					await dialogue_box.closed
			queue_free()
		State.DEFEAT:
			dialogue_box.add_text(["The party folds under the pressure..."])
			queue_free()
		_:
			event_queue.clear()
			dialogue_box.advance()
			await dialogue_box.closed
			animate_options(_info_options,true)
			animate_options(dialogue_box,false)
			goto_next_player()
			return

func _on_optionmenu_button_pressed(button: BaseButton) -> void:
	match button.text:
		"HIT":
			current_action = Action.HIT
			_enemies_menu.button_focus()
		"TRICK":
			current_action = Action.TRICK
			_trick_menu.button_focus()
		"STAND":
			current_action = Action.STAND
			add_player_event(current_action)
		"FOLD":
			queue_free()

func _on_trickmenu_button_pressed(button: BaseButton) -> void:
	match button.text:
		"A":
			current_trick = Trick.A
		"B":
			current_trick = Trick.B
		"C":
			current_trick = Trick.C
		"D":
			current_trick = Trick.D
		_:
			current_trick = -1
	#add_event(Data.party[current_party_index],current_action, current_target)
	_option_menu.button_focus()

func _on_battle_actor_defeated(_actor: BattleActor) -> void:
	dialogue_box.add_text(["The " + _actor.name + " lost the bet..."])
	if !_actor.friendly:
		xp_gained   += _actor.xp
		gold_gained += _actor.gold

func _on_player_hp_changed(_hp: int, change: int) -> void:
	if change < 0:
		_screenshake.add_trauma(0.3)
		Util.screen_flash(self,"HIT", true)

func _on_battle_actor_pressed(_actor_button: BattleActorButton) -> void:
	var button_data = _actor_button.data 
	if button_data.friendly:
#		Player Button
		_option_menu.button_focus()
	else:
#		Enemy Button
		current_target = button_data
		add_player_event(current_action, current_target)
