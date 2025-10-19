class_name SpellShopMiddle extends ShopMiddle

@onready var spells: Menu = $MarginContainer/HBoxContainer/Spells
@onready var level_labels: Array = $MarginContainer/HBoxContainer/Levels.get_children()
@onready var price_labels: Array = $MarginContainer/HBoxContainer/Price.get_children()
@onready var ronin: Label = $MarginContainer/HBoxContainer/Party/Ronin
@onready var stowaway: Label = $MarginContainer/HBoxContainer/Party/Stowaway
@onready var mercenary: Label = $MarginContainer/HBoxContainer/Party/Mercenary
@onready var bastard: Label = $MarginContainer/HBoxContainer/Party/Bastard

func _ready() -> void:
	set_shop_menu(spells)
