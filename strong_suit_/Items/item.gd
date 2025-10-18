class_name Item extends Resource

enum Rarities {
	BASIC,
	COMMON,
	UNCOMMON,
	RARE,
	SCARCE,
	UNIQUE,
	LEGENDARY
}

enum Type {
	CONSUMABLE,
	CARD,
	UPGRADE
}

enum Stats {
	POWER,
	DEFENSE,
	SPEED,
	NO_STAT
}

var name: String = ""
var quantity: int = 1
var quantity_max: int = 99
var cost: int = 1
var rarity: int = -1
var desc: String = ""
var type: int = -1
var stat: int = -1
var attribute: float = 1.0

func _init(_type: int = type, _stat: int = stat, _cost: int = cost, _rarity: int = rarity, _desc: String = desc) -> void:
	cost = _cost
	rarity = _rarity
	type = _type
	stat = _stat
	desc = _desc
	attribute = snappedf(clampf(randf_range(-4.0,4.0) + rarity,1.0,10.0),0.125)

func set_name_custom(_name: String) -> void:
	name = _name

func is_armor() -> bool:
	return type in [Type.UPGRADE]

func duplicate_custom() -> Item:
	var dup: Item = self.duplicate()
	dup._init(type, stat, cost, rarity, desc)
	dup.name = name
	dup.quantity = clampi(quantity, 0, quantity_max)
	return dup
