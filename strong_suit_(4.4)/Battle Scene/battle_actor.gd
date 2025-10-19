class_name BattleActor extends Resource

signal hp_changed(hp: int, change: int)
signal fm_changed(fm: int, change: int)
signal equipment_changed()
signal defeated()
signal acting()

enum Slots {
	MAINHAND,
	OFFHAND,
	HEAD,
	TORSO,
	LEGS
}

const STATS: Dictionary = Data.STATS
const ELEMENTS: Dictionary = Data.ELEMENTS
const MAX_SPELLS_PER_LEVEL: int = 3

var hp_max: int = -1
var fm_max: int = 100

var hp: int = hp_max
var fm: int = fm_max
var speed:        float = -1
var defense:      float = -1
var attack:       float = -1
var accuracy:     float = -1
var stamina:      float = -1
var intellect:    float = -1
var power:        float = -1

var xp:    int = -1
var gold:  int = -1
var level: int = -1

var name: String = "Not_Set"
var texture: Texture = null
var friendly: bool = false
var is_standing: bool = false
var cards: Array = []
var learned_spells: Array = []
var prepared_spells: Array = []
var castable_elements: Array = []

func _init(_stamina: int = stamina, _power: int = power, _def: int = defense, _speed: int = speed, _lvl: int = level) -> void:
	power = _power
	defense = _def
	speed = _speed
	stamina = _stamina
	level = _lvl
	attack = power * level
	hp_max = stamina * level
	accuracy = round((speed / defense) * level) if speed > defense else round((defense / speed) * level)
	intellect = round((power + defense + speed) * level/3)
	hp = hp_max
	xp = _lvl * 5
	gold =  _lvl * 3


func init_cards() -> void:
	cards.resize(Slots.size())
	cards.fill(null)

func init_spells() -> void:
	learned_spells.resize(Spell.LEVELS  * MAX_SPELLS_PER_LEVEL)
	learned_spells.fill(null)
	prepared_spells.resize(Spell.LEVELS)
	prepared_spells.fill(null)

func set_name_custom(value: String) -> void:
	name = value
	var name_formatted: String = name.to_lower().replace(" ","_")
	if friendly:
		texture = load("res://Battle Scene/Art/Party/" + name_formatted+ ".png")
	else:
		texture = load("res://Battle Scene/Art/Enemies/" + name_formatted+ ".png")
	match name:
		"Ronin":
			castable_elements = [ELEMENTS.FIRE, ELEMENTS.LIGHTNING]
		"Stowaway":
			castable_elements = [ELEMENTS.AIR, ELEMENTS.POISON]
		"Mercenary":
			castable_elements = [ELEMENTS.WATER, ELEMENTS.ICE]
		"Bastard":
			castable_elements = [ELEMENTS.EARTH, ELEMENTS.AIR]

func get_defense(with_armor_rating: bool) -> int:
	var value: int = defense
	if with_armor_rating:
		for item in cards:
			if item:
				value += item.attribute
	return value

func healhurt(value: int) -> int:
	var hp_start: int = hp
	var change: int = 0
	
	if value < 0:
		var spread: float = 0.2
		if is_standing:
			value *= 0.4 + randf_range(-spread,spread)
	
	hp = clampi(hp + value, 0, hp_max)
	change = hp - hp_start
	hp_changed.emit(hp, change)
	print(change)
	if !has_hp():
		defeated.emit()
	return change

func change_fm(value: int) -> int:
	var fm_start: int = fm
	var change: int = 0
	
	fm = clampi(fm + value, 0, fm_max)
	change = fm - fm_start
	fm_changed.emit(fm, change)
	return change

func speed_roll() -> int:
	return Math.add_with_random_spreadi(speed, 4)

func damage_roll() -> int:
	return -Math.add_with_random_spreadf(power, 0.25)

func stand() -> void:
	is_standing = true

func add_xp(value: int) -> void:
	xp += value

func add_gold(value:int) -> void:
	gold += value

func get_equipment_at_slot(slot: int) -> Item:
	if cards[slot]:
		return cards[slot]
	else:
		return null

func get_spell_at_index(index: int) -> Spell:
	if index < learned_spells.size():
		return learned_spells[index]
	else:
		return null

func get_total_learned_spells() -> int:
	var count: int = 0
	for spell in learned_spells:
		if spell:
			count += 1
	return count

func is_spells_empty() -> bool:
	for spell in learned_spells:
		if spell:
			return false
	return true

func learn_spell(_spell: Spell) -> void:
	var spell_level: int = _spell.level -1
	var start_index: int = MAX_SPELLS_PER_LEVEL * spell_level
	for i in range(start_index, start_index + MAX_SPELLS_PER_LEVEL):
		if learned_spells[i]:
			if learned_spells[i] == _spell:
				return
		else:
			if castable_elements.has(_spell.element):
				
				learned_spells[i] = _spell
				return

func forget_spell(_spell: Spell) -> void:
	if _spell and learned_spells.has(_spell):
		learned_spells[learned_spells.find(_spell)] = null
	unprepare_spell(_spell)

func is_spell_prepared(_spell: Spell) -> bool:
	return prepared_spells.has(_spell)

func prepare_spell(_spell:Spell) -> void:
	var spell_is_learned: bool = learned_spells.has(_spell)
	if spell_is_learned:
		var spell_level: int = _spell.level
		prepared_spells[spell_level] = _spell
	else:
		print("no")

func unprepare_spell(_spell: Spell) -> void:
	if _spell and prepared_spells.has(_spell):
		prepared_spells[prepared_spells.find(_spell)] = null

func equip(item: Item, slot: int) -> void:
	var equipped_item: Item = cards[slot]
	if equipped_item:
		if equipped_item.stat == Item.Stats.DEFENSE:
			defense -= equipped_item.attribute
		elif equipped_item.stat == Item.Stats.POWER:
			power -= equipped_item.attribute
		elif equipped_item.stat == Item.Stats.SPEED:
			speed -= equipped_item.attribute
		Data.player_inventory.add_item_by_name(equipped_item.name,1)

	cards[slot] = item
	if item:
		if item.stat == Item.Stats.DEFENSE:
			defense += item.attribute
		elif item.stat == Item.Stats.POWER:
			power += item.attribute
		elif item.stat == Item.Stats.SPEED:
			speed += item.attribute
	attack = power + level
	accuracy = (speed - defense) * level
	equipment_changed.emit()

func duplicate_custom() -> BattleActor:
	var dup: BattleActor = self.duplicate()
	dup._init(hp_max,power,defense,speed,level)
	dup.name = name
	dup.texture = texture
	return dup

func can_act() -> bool:
	return has_hp()

func has_hp() -> bool:
	return hp > 0

func act() -> void:
	acting.emit()
