class_name SpellButton extends Button

var spell: Spell = null
var is_spell_prepared: bool = false

func _ready() -> void:
	if !spell:
		modulate.a = 0.0
		disabled = true

func set_spell(new_spell: Spell) -> void:
	spell = new_spell
	if spell:
		text = spell.name
		modulate.a = 1.0
		disabled = false
	else:
		modulate.a = 0.0
		disabled = true
