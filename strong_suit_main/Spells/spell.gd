class_name Spell extends Resource

enum Types {
	DAMAGE,
	INFLICT_STATUS,
	HEAL,
	BUFF_STAT,
	EFFECT,
	CLEANSE_STATUS,
}

enum Targets {
	SELF,
	SINGLE,
	MASS
}

enum Elements {
	WATER,
	FIRE,
	LIGHTNING,
	ICE,
	AIR,
	EARTH,
	POISON,
	#SLIME,
	#MAGMA,
	TIME,
	#AETHER
}

const LEVELS: int = 8

var name: String = ""
var type: int 
var target: int
var element: int
var power: int = -1
var desc: String = ""
var level: int = -1
var cost: int = -1

func _init(_lvl: int = level, _cost: int = cost, _element: int = element, _type: int = type, _target: int = target, _desc: String = desc) -> void:
	level = _lvl
	cost = _cost
	element =_element
	type = _type
	target = _target
	desc = _desc
	match element:
		Elements.WATER:
			match type:
				Types.HEAL:
					power = (level+cost)*4 if target == Targets.SINGLE else (level*cost)
				Types.DAMAGE:
					power = (10*level)+10
		Elements.FIRE:
			match type:
				Types.DAMAGE:
					power = 10*level
				Types.BUFF_STAT:
					power = cost + (2*level)
		Elements.AIR:
			match type:
				Types.INFLICT_STATUS:
					power = 20
				Types.BUFF_STAT:
					if target == Targets.SELF:
						power = 16
					else:
						power =  40
		Elements.ICE:
			match type:
				Types.DAMAGE:
					power = 10*level
		Elements.LIGHTNING:
			match type:
				Types.DAMAGE:
					power = 10*level
				Types.BUFF_STAT:
					power = 80
		Elements.EARTH:
			match type:
				Types.BUFF_STAT:
					power = 12 if target == Targets.MASS else 8 
		Elements.POISON:
			pass
		Elements.TIME:
			match type:
				Types.DAMAGE:
					power = cost * 2

func get_type() -> Types:
	return type

func set_name_custom(_name: String) -> void:
	name = _name
