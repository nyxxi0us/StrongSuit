class_name Actor extends Node2D

@export var max_hp: int = 10
var hp: int = 10
@export var base_armor: int = 0
var armor: int = 0
@export var max_energy: int = 21
var energy: int = 0
@onready var health: ProgressBar = $Health
@onready var armor_icon: Sprite2D = $Armor
@onready var armor_amount: Label = $Armor/ArmorAmount


func _ready() -> void:
	reset()

func reset() -> void:
	hp = max_hp
	energy = max_energy
	armor = base_armor
	update_armor()
	update_health()

func set_stats(_hp: int = max_hp, _max_hp: int = max_hp) -> void:
	max_hp = _max_hp
	hp = _hp
	update_health()

func update_armor():
	if armor_amount.text != str(armor):
		armor_amount.text = str(armor)
	if armor > 0:
		armor_icon.visible = true
	else: 
		armor_icon.visible = false

func update_health():
	if health.max_value != max_hp:
		health.max_value = max_hp
		health.step = max_hp/100
	if health.value != hp:
		health.value = hp

func healhurt(amount: int) -> void:
	if amount < 0:
		amount = min(amount+armor, 0)
	hp = clampi(hp + amount, 0, max_hp)
	update_health()

func start_turn() -> void:
	armor = 0
	energy = max_energy

func add_armor(amount: int) -> void:
	armor += amount
	update_armor()

func spend_energy(amount: int) -> void:
	energy = clampi(energy - amount, 0, max_energy)

func _process(_delta: float) -> void:
	update_health()
	update_armor()
