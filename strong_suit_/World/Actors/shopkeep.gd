class_name Shopkeep extends Actor

@export var inventory_index: int = 0
@onready var is_spell_shop: bool = false
@onready var inventory: Inventory = Data.inventories[inventory_index]
@onready var shop_gui: ShopGUI = $CanvasLayer/ShopGui

func _ready() -> void:
	shop_gui.set_inventory(inventory)
	if inventory_index > 3:
		is_spell_shop = true
	shop_gui.spell_shop_middle.visible = is_spell_shop

func open(on: bool) -> void:
	shop_gui.enable(on)

func _on_interaction_range_interact_requested() -> void:
	if !shop_gui.is_visible_in_tree():
		open(true)
