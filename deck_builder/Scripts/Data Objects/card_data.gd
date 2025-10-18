class_name CardData extends Resource

@export var card_rank   : int = -1
@export_enum("Earth","Fire","Water","Air","Aether") var card_suit: int = -1
@export var suit_damage : int = -1
@export var suit_defense: int = -1
@export var suit_bonus  : int = -1
@export var actions: Array[GDScript] = []
