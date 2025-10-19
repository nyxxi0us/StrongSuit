extends Node

signal player_gold_changed(new_value: int)

const DEBUG_HP: bool = true
const RARITIES: Dictionary = Item.Rarities
const ITEM_TYPES: Dictionary = Item.Type
const STATS: Dictionary = Item.Stats
const ELEMENTS: Dictionary = Spell.Elements
const S_TYPES: Dictionary = Spell.Types
const TARGETS: Dictionary = Spell.Targets

static var tile_transitions: Dictionary[Vector2,String] = {
	Vector2(2.0,-1.0):   "Town0",
	Vector2(-7.0, 3.0):  "Town1",
	Vector2(-12.0,-3.0): "Town2",
	Vector2(4.0,5.0):    "Camp0",
	Vector2(-8.0,-6.0):  "Camp1",
	Vector2(1.0,10.0):   "Chest0",
	Vector2(6.0,-9.0):   "Chest1",
	Vector2(8.0,-4.0):   "Gate0",
}

static var players: Dictionary = {
	"Ronin":     BattleActor.new(25,3,2,5,1),
	"Stowaway":  BattleActor.new(26,3,5,3,1),
	"Mercenary": BattleActor.new(27,5,3,1,1),
	"Bastard":   BattleActor.new(23,4,2,4,1),
	#"Viking": BattleActor.new(30,1),
} if DEBUG_HP else {
	"Ronin":     BattleActor.new(10,1,1,5,1),
	"Stowaway":  BattleActor.new(10,1,1,3,1),
	"Mercenary": BattleActor.new(10,1,1,1,1),
	"Bastard":   BattleActor.new(10,1,1,4,1),
	#"Viking": BattleActor.new(30,1),
}

static var enemies: Dictionary = {
	"Oni" : BattleActor.new(10,1,0,2,5),
	"Fae" : BattleActor.new(5,2,3,5,1),
	"Alp" : BattleActor.new(10,1,2,3,5),
	"Olgoi":BattleActor.new(20,3,2,7,3),
	#"Draugr" : BattleActor.new(20,4)
} if !DEBUG_HP else {
	"Oni" : BattleActor.new(1,1,2,5),
	"Fae" : BattleActor.new(1,1,5,1),
	"Alp" : BattleActor.new(1,1,3,5),
	"Olgoi":BattleActor.new(1,1,2,7,3),
	#"Draugr" : BattleActor.new(20,4)
}

var spells: Dictionary = {
	"Spark":  Spell.new(1, 5, ELEMENTS.FIRE, S_TYPES.DAMAGE, TARGETS.SINGLE,"Deals fire damage to one enemy!"),
	"Zap":    Spell.new(1, 5, ELEMENTS.LIGHTNING, S_TYPES.DAMAGE, TARGETS.SINGLE, "Deals lightn. damage to one enemy!"),
	"Focus":  Spell.new(1, 3, ELEMENTS.AIR, S_TYPES.INFLICT_STATUS, TARGETS.SINGLE, "Makes one enemy easier to hit!"),
	"Sleep":  Spell.new(1, 3, ELEMENTS.WATER, S_TYPES.INFLICT_STATUS, TARGETS.SINGLE, "Puts all enemies to sleep!"),
	"Stitch": Spell.new(1, 3, ELEMENTS.WATER, S_TYPES.HEAL, TARGETS.SINGLE, "Heals one ally!"),
	"Shield": Spell.new(1, 3, ELEMENTS.EARTH, S_TYPES.BUFF_STAT, TARGETS.SINGLE, "Raise one ally's defense!"),
	"Prayer": Spell.new(1, 5, ELEMENTS.WATER, S_TYPES.DAMAGE, TARGETS.MASS, "Damages any undead enemies!"),
	"Blink":  Spell.new(1, 3, ELEMENTS.LIGHTNING, S_TYPES.BUFF_STAT, TARGETS.SELF, "Raise own evasion greatly!"),
	
	"Obscure":  Spell.new(2, 5, ELEMENTS.POISON, S_TYPES.INFLICT_STATUS, TARGETS.MASS, "Blinds all enemies!"),
	"Flake":    Spell.new(2, 8, ELEMENTS.ICE, S_TYPES.DAMAGE, TARGETS.SINGLE, "Deals ice damage to one enemy!"),
	"Ice":      Spell.new(2, 5, ELEMENTS.ICE, S_TYPES.INFLICT_STATUS, TARGETS.MASS, "Reduces # of all enemy attacks!"),
	"Duel":     Spell.new(2, 10,  ELEMENTS.FIRE, S_TYPES.BUFF_STAT, TARGETS.SINGLE, "Prepares one ally for a fight!"),
	"Ground":   Spell.new(2, 8, ELEMENTS.LIGHTNING, S_TYPES.EFFECT, TARGETS.MASS, "Halves lightning damage for party!"),
	"Disapear": Spell.new(4, 5, ELEMENTS.AIR, S_TYPES.BUFF_STAT, TARGETS.SINGLE, "Raise one ally's evasion!"),
	"Lamp":     Spell.new(2, 3, ELEMENTS.POISON, S_TYPES.CLEANSE_STATUS, TARGETS.SINGLE, "Returns an ally's sight!"),
	"Mute":     Spell.new(2, 5, ELEMENTS.AIR, S_TYPES.INFLICT_STATUS, TARGETS.MASS, "Silences all enemies!"),
	
	"Flame":    Spell.new(3, 15, ELEMENTS.FIRE, S_TYPES.DAMAGE, TARGETS.MASS, "Deals fire damage to all enemies!"),
	"Stun":     Spell.new(3, 10, ELEMENTS.LIGHTNING, S_TYPES.INFLICT_STATUS, TARGETS.SINGLE, "Paralyzes one enemy!"),
	"Strike":   Spell.new(3, 15, ELEMENTS.LIGHTNING, S_TYPES.DAMAGE, TARGETS.MASS, "Deals lightn. damage to all enemies!"),
	"Strategy": Spell.new(3, 10, ELEMENTS.AIR, S_TYPES.INFLICT_STATUS, TARGETS.MASS, "Makes all enemies easier to hit!"),
	"Douse":    Spell.new(3, 8, ELEMENTS.FIRE, S_TYPES.EFFECT, TARGETS.MASS, "Halves fire damage for party!"),
	"Bandage":  Spell.new(3, 10, ELEMENTS.WATER, S_TYPES.HEAL, TARGETS.SINGLE, "Heals one ally more!"),
	"Toast":    Spell.new(3, 10, ELEMENTS.WATER, S_TYPES.HEAL, TARGETS.MASS, "Heals all allies!"),
	"Exorcise": Spell.new(3, 12, ELEMENTS.WATER, S_TYPES.DAMAGE, TARGETS.MASS, "Damages any undead enemies more!"),
	
	"Confuse": Spell.new(4, 15, ELEMENTS.WATER, S_TYPES.INFLICT_STATUS, TARGETS.MASS, "Makes enemies attack each other!"),
	"Boost":   Spell.new(4, 15, ELEMENTS.LIGHTNING, S_TYPES.BUFF_STAT, TARGETS.SINGLE, "Doubles # of one ally's attacks!"),
	"Snow":    Spell.new(4, 18, ELEMENTS.ICE, S_TYPES.DAMAGE, TARGETS.MASS, "Deals ice damage to all enemies!"),
	"Coma":    Spell.new(4, 15, ELEMENTS.WATER, S_TYPES.INFLICT_STATUS, TARGETS.SINGLE, "Puts one enemy to sleep!"),
	"Shelter": Spell.new(4, 8, ELEMENTS.ICE, S_TYPES.EFFECT, TARGETS.MASS, "Halves ice damage for party!"),
	"Amplify": Spell.new(4, 3, ELEMENTS.AIR, S_TYPES.CLEANSE_STATUS, TARGETS.SINGLE, "Returns an ally's voice!"),
	"Mock":    Spell.new(4, 10, ELEMENTS.AIR, S_TYPES.INFLICT_STATUS, TARGETS.MASS, "Demoralizes all enemies!"),
	"Purify":  Spell.new(4, 3, ELEMENTS.POISON, S_TYPES.CLEANSE_STATUS, TARGETS.SINGLE, "Cures an ally of poison!"),
	
	"Plague":    Spell.new(5, 28, ELEMENTS.POISON, S_TYPES.INFLICT_STATUS, TARGETS.MASS, "Fataly infects all enemies!"),
	"Frostbite": Spell.new(5, 30, ELEMENTS.ICE, S_TYPES.INFLICT_STATUS, TARGETS.SINGLE, "Reduces # of one enemy's attacks!"),
	"Inferno":   Spell.new(5, 18, ELEMENTS.FIRE, S_TYPES.DAMAGE, TARGETS.MASS, "Deals fire+ damage to all enemies!"),
	#"Teleport": "Placeholder",
	"Triage":    Spell.new(5, 20, ELEMENTS.WATER, S_TYPES.HEAL, TARGETS.SINGLE, "Heals one ally the most!"),
	"Feast":     Spell.new(5, 25, ELEMENTS.WATER, S_TYPES.HEAL, TARGETS.MASS, "Heals all allies more!"),
	"Banish":    Spell.new(5, 25, ELEMENTS.WATER, S_TYPES.DAMAGE, TARGETS.MASS, "Damages any undead enemies the most!"),
	"Miracle":   Spell.new(5, 20, ELEMENTS.WATER, S_TYPES.EFFECT, TARGETS.SINGLE, "Bring an ally back into the fight!"),
	
	"Storm":     Spell.new(6, 35, ELEMENTS.LIGHTNING, S_TYPES.DAMAGE, TARGETS.MASS, "Deals lightn.+ damage to all enemies!"),
	"Quake":     Spell.new(6, 32, ELEMENTS.EARTH, S_TYPES.INFLICT_STATUS, TARGETS.MASS, "Cracks the ground beneath enemies!"),
	"Poison":    Spell.new(6, 30, ELEMENTS.POISON, S_TYPES.INFLICT_STATUS, TARGETS.SINGLE, "Fataly infects one enemy!"),
	"Synapse":   Spell.new(6, 20, ELEMENTS.LIGHTNING, S_TYPES.INFLICT_STATUS, TARGETS.SINGLE, "Paralyzes a certain enemy!"),
	#"Exit": "Placeholder",
	"Barricade": Spell.new(6, 20, ELEMENTS.EARTH, S_TYPES.BUFF_STAT, TARGETS.MASS, "Raise all allies defense!"),
	"Vanish":    Spell.new(6, 25, ELEMENTS.AIR, S_TYPES.BUFF_STAT, TARGETS.MASS, "Raise all allies evasion!"),
	"Erode":     Spell.new(6, 10, ELEMENTS.EARTH, S_TYPES.CLEANSE_STATUS, TARGETS.SINGLE, "Cures petrification from an ally!"),
	
	"Blind":    Spell.new(7, 25, ELEMENTS.POISON, S_TYPES.INFLICT_STATUS, TARGETS.SINGLE, "Blinds a certain enemy!"),
	"Petrify":  Spell.new(7, 30, ELEMENTS.EARTH, S_TYPES.INFLICT_STATUS, TARGETS.SINGLE, "Turns one enemey to stone!"),
	"Blizzard": Spell.new(7, 40, ELEMENTS.ICE, S_TYPES.DAMAGE, TARGETS.MASS, "Deals ice+ damage to all enemies!"),
	"Train":    Spell.new(7, 25, ELEMENTS.AIR, S_TYPES.BUFF_STAT, TARGETS.SELF, "Raises own attack/accuracy!"),
	"Heroism":  Spell.new(7, 30, ELEMENTS.TIME, S_TYPES.EFFECT, TARGETS.MASS, "Protects the party from almost anything!"),
	"Recovery": Spell.new(7, 40, ELEMENTS.WATER, S_TYPES.EFFECT, TARGETS.SINGLE, "Fully heals and cures one ally!"),
	"Banquet":  Spell.new(7, 25, ELEMENTS.WATER, S_TYPES.HEAL, TARGETS.MASS, "Heals all allies the most!"),
	"Crusade":  Spell.new(7, 28, ELEMENTS.WATER, S_TYPES.DAMAGE, TARGETS.MASS, "Damages any undead enemies even further!"),
	
	"Judgement": Spell.new(8, 50, ELEMENTS.TIME, S_TYPES.DAMAGE, TARGETS.MASS, "Deals massive damage to all enemies!"),
	"Pause":     Spell.new(8, 30, ELEMENTS.TIME, S_TYPES.INFLICT_STATUS, TARGETS.MASS, "Pauses time for all enemies!"),
	"Death":     Spell.new(8, 40, ELEMENTS.TIME, S_TYPES.INFLICT_STATUS, TARGETS.SINGLE, "Sends an enemy to their death."),
	"Skip":      Spell.new(8, 38, ELEMENTS.TIME, S_TYPES.INFLICT_STATUS, TARGETS.MASS, "Skip to the end of the fight."),
	"Rapture":   Spell.new(8, 50, ELEMENTS.TIME, S_TYPES.DAMAGE, TARGETS.MASS, "Deals massive damage to all enemies!"),
	"Rewind":    Spell.new(8, 40, ELEMENTS.TIME, S_TYPES.EFFECT, TARGETS.SINGLE, "Resets a downed ally to full health!"),
	"Phase":     Spell.new(8, 40, ELEMENTS.TIME, S_TYPES.EFFECT, TARGETS.SINGLE, "Halves all damage to one ally!"),
	"Reveal":    Spell.new(8, 35, ELEMENTS.TIME, S_TYPES.INFLICT_STATUS, TARGETS.SINGLE, "Removes all defenses from an enemy!")
}

var cards: Dictionary = {
	#"2 of Wands":  Card.new(),
	#"3 of Wands":  Card.new(),
	#"4 of Wands":  Card.new(),
	#"5 of Wands":  Card.new(),
	#"6 of Wands":  Card.new(),
	#"7 of Wands":  Card.new(),
	#"8 of Wands":  Card.new(),
	#"9 of Wands":  Card.new(),
	#"10 of Wands": Card.new(),
	#"P of Wands":  Card.new(),
	#"Q of Wands":  Card.new(),
	#"K of Wands":  Card.new(),
	#"A of Wands":  Card.new(),
	#"2 of Daggers":  Card.new(),
	#"3 of Daggers":  Card.new(),
	#"4 of Daggers":  Card.new(),
	#"5 of Daggers":  Card.new(),
	#"6 of Daggers":  Card.new(),
	#"7 of Daggers":  Card.new(),
	#"8 of Daggers":  Card.new(),
	#"9 of Daggers":  Card.new(),
	#"10 of Daggers": Card.new(),
	#"P of Daggers":  Card.new(),
	#"Q of Daggers":  Card.new(),
	#"K of Daggers":  Card.new(),
	#"A of Daggers":  Card.new(),
	#"2 of Mirrors":  Card.new(),
	#"3 of Mirrors":  Card.new(),
	#"4 of Mirrors":  Card.new(),
	#"5 of Mirrors":  Card.new(),
	#"6 of Mirrors":  Card.new(),
	#"7 of Mirrors":  Card.new(),
	#"8 of Mirrors":  Card.new(),
	#"9 of Mirrors":  Card.new(),
	#"10 of Mirrors": Card.new(),
	#"P of Mirrors":  Card.new(),
	#"Q of Mirrors":  Card.new(),
	#"K of Mirrors":  Card.new(),
	#"A of Mirrors":  Card.new(),
	#"2 of Wheels":  Card.new(),
	#"3 of Wheels":  Card.new(),
	#"4 of Wheels":  Card.new(),
	#"5 of Wheels":  Card.new(),
	#"6 of Wheels":  Card.new(),
	#"7 of Wheels":  Card.new(),
	#"8 of Wheels":  Card.new(),
	#"9 of Wheels":  Card.new(),
	#"10 of Wheels": Card.new(),
	#"P of Wheels":  Card.new(),
	#"Q of Wheels":  Card.new(),
	#"K of Wheels":  Card.new(),
	#"A of Wheels":  Card.new()
}

var items: Dictionary = {
	"Notch":            Item.new(ITEM_TYPES.UPGRADE, STATS.SPEED, 15, RARITIES.BASIC,     "Makes a slot quick as a flash!"),
	"Sleeve":           Item.new(ITEM_TYPES.UPGRADE, STATS.DEFENSE, 15, RARITIES.BASIC,     "Makes a slot more protective. Shiny!"),
	"Foil":             Item.new(ITEM_TYPES.UPGRADE, STATS.POWER, 15, RARITIES.BASIC,     "Makes a slot pack some power!"),
	"Dice":             Item.new(ITEM_TYPES.CONSUMABLE, STATS.NO_STAT, 5, RARITIES.BASIC,   "Roll the dice! Use: 1 Encounter"),
	"Chip":             Item.new(ITEM_TYPES.CONSUMABLE, STATS.NO_STAT, 20, RARITIES.BASIC,  "Up the stakes! Use: All DMG++"),
	"Tarot Reading":    Item.new(ITEM_TYPES.CONSUMABLE, STATS.NO_STAT, 30, RARITIES.COMMON, "Peer past the veil... "),
	"Rand. Card":       Item.new(ITEM_TYPES.CARD, STATS.NO_STAT, 10, RARITIES.BASIC,        "Adds a random card to deck"),
	"Rand. Wnd. Card":  Item.new(ITEM_TYPES.CARD, STATS.NO_STAT, 20, RARITIES.COMMON,       "Adds a random wands card to deck"),
	"Rand. Dgr. Card":  Item.new(ITEM_TYPES.CARD, STATS.NO_STAT, 20, RARITIES.COMMON,       "Adds a random dagger card to deck"),
	"Rand. Mrr. Card":  Item.new(ITEM_TYPES.CARD, STATS.NO_STAT, 20, RARITIES.COMMON,       "Adds a random mirror card to deck"),
	"Rand. Whl. Card":  Item.new(ITEM_TYPES.CARD, STATS.NO_STAT, 20, RARITIES.COMMON,       "Adds a random wheel card to deck"),
}

var inventories: Array[Inventory] = []
var player_inventory: Inventory
var player_gold: int = 1000:
	set(n):
		player_gold = n
		player_gold_changed.emit(player_gold)

var party: Array = players.values()
var enemy_list: Array = enemies.values()
var spell_list: Array = spells.values()
var party_index: int = 0

func _ready() -> void:
	for player in party:
		player.friendly = true
	Util.set_keys_to_names(players)
	Util.set_keys_to_names(enemies)
	Util.set_keys_to_names(spells)
	Util.set_keys_to_names(items)
	for player in party:
		player.init_cards()
		player.init_spells()
		for spell in spell_list:
			if player.castable_elements.has(spell.element):
				player.learn_spell(spell)
	player_inventory = Inventory.new(Inventory.PLAYER)
	inventories = [
	Inventory.new(Inventory.DEALER),
	Inventory.new(Inventory.MYSTIC),
	Inventory.new(Inventory.SMITH)
	]
