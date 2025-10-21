class_name SpellShopMiddle extends ShopMiddle

@onready var party: Array = $MarginContainer/HBoxContainer/Party.get_children()
@onready var ronin: Label = $MarginContainer/HBoxContainer/Party/Ronin
@onready var stowaway: Label = $MarginContainer/HBoxContainer/Party/Stowaway
@onready var mercenary: Label = $MarginContainer/HBoxContainer/Party/Mercenary
@onready var bastard: Label = $MarginContainer/HBoxContainer/Party/Bastard

var inventory: Inventory = null

func _ready() -> void:
	levels = $MarginContainer/HBoxContainer/Levels

func update_shop_labels(current_item: Item) -> void:
	var spell_name: String = current_item.name.right("Tome of ".length())
	var shop_spell: Spell = Data.spells.get(spell_name)
	
	if shop_spell:
		for i in range(Data.party.size()):
			if shop_spell.element in Data.party[i].castable_elements:
				party[i].show()
			else:
				party[i].hide()
