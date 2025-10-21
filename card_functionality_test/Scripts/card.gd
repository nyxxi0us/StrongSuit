class_name Card extends Node2D

signal mouse_entered(card: Card)
signal mouse_exited(card: Card)

var card_values: Dictionary = {
	"Mainhand":  -1,
	"OffHand":   -1,
	"Helm":      -1,
	"Chest":     -1,
	"Legs":      -1,
	"Bonus Stat":-1,
}

var card_name: String = ""
var card_desc: String = ""
var suit_color: Color = Color.WEB_GRAY
var converted_rank: String =""
var card_suit_name: String = ""

@export var card_rank   : int = -1
@export_enum("Earth","Fire","Water","Air","Aether") var card_suit: int = -1
@export var suit_damage : int = -1
@export var suit_defense: int = -1
@export var suit_bonus  : int = -1


@onready var rank_displays: Array = $BaseCardSprite/RankDisplay.get_children()
@onready var odd_even: Sprite2D = $BaseCardSprite/SuitDisplay/Odd_even
@onready var base_card_sprite: Sprite2D = $BaseCardSprite
@onready var area_2d: Area2D = $BaseCardSprite/Area2D

func _ready() -> void:
	set_card_values(card_suit,card_rank)

func _process(_delta: float) -> void:
	update_graphics()

func set_card_values(new_suit: int, new_rank: int) -> void:
	card_rank =clampi(new_rank, 1,13)
	card_suit =clampi(new_suit, 0,4)
	var rank_mult: int = 14 if card_rank == 1 else card_rank
	
	match card_suit:
			0:
				suit_color = Color.GOLDENROD
				card_suit_name = "Wheels"
				suit_damage = 3
				suit_defense = 6
				suit_bonus = 1
			1:
				suit_color = Color.FIREBRICK
				card_suit_name = "Batons"
				suit_damage = 5
				suit_defense = 4
				suit_bonus = 1
			2:
				suit_color = Color.CYAN
				card_suit_name = "Hearts"
				suit_damage = 2
				suit_defense = 5
				suit_bonus = 3
			3:
				suit_color = Color.DARK_SEA_GREEN
				card_suit_name = "Daggers"
				suit_damage = 6
				suit_defense = 3
				suit_bonus = 1
			4:
				suit_color = Color.PURPLE
				card_suit_name = "Sigils"
				suit_damage = 2
				suit_defense = 1
				suit_bonus = 7
	match card_rank:
		1:
			converted_rank = "A"
			card_name = "Ace of " + card_suit_name
		11: 
			converted_rank = "P"
			card_name = "Page of " + card_suit_name
		12:
			converted_rank = "Q"
			card_name = "Queen of " + card_suit_name
		13:
			converted_rank = "K"
			card_name = "King of " + card_suit_name
		_:
			converted_rank = str(new_rank)
			card_name = converted_rank + " of " + card_suit_name
	
	for key in card_values.keys():
		match key:
			"Mainhand":
				card_values[key] = (suit_damage) * rank_mult
			"OffHand":
				card_values[key] = (suit_damage / 2) * rank_mult
			"Helm":
				card_values[key] = (suit_defense / 2) * rank_mult
			"Chest":
				card_values[key] = (suit_defense) * rank_mult
			"Legs":
				card_values[key] = (suit_defense * 2/3) * rank_mult
			"Bonus Stat":
				card_values[key] = (suit_bonus) * rank_mult
	update_graphics()

func update_graphics() -> void:
	for lbl in rank_displays:
		if lbl.get_text() != converted_rank:
			lbl.set_text(converted_rank)
		if lbl.self_modulate != suit_color:
			lbl.self_modulate = suit_color
	odd_even.frame = card_suit

func highlight(on: bool):
	if on:
		base_card_sprite.modulate = Color.PALE_GOLDENROD
	else:
		base_card_sprite.modulate = Color.WHITE

func _on_area_2d_mouse_entered() -> void:
	mouse_entered.emit(self)

func _on_area_2d_mouse_exited() -> void:
	mouse_exited.emit(self)

#func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#pass # Replace with function body.
