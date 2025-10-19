class_name BattleActorButton extends TextureButton

const HIT_TEXT = preload("res://Util/hit_text.tscn")

var data: BattleActor = null
var tween: Tween = null

@onready var dir: int = 1
@onready var start_pos : Vector2 = position
@onready var recoil_bounce = 8*randf()

func set_data(_data: BattleActor) -> void:
	data = _data
	if data.texture:
		set_texture_normal(data.texture)
	data.hp_changed.connect(_on_data_hp_changed)
	data.defeated.connect(_on_data_defeated)
	data.acting.connect(_on_data_acting)
	
	dir = 1 if !data.friendly else -1

func _on_data_hp_changed(_hp: int, change: int) -> void:
	var hit_text: HitText = HIT_TEXT.instantiate()
	owner.add_child(hit_text)
	hit_text.init(change,self,HitText.BOUNCING)
	if sign(change) == -1:
		recoil()
		set_process(true)
		await get_tree().create_timer(GlobalScript.DEFAULT_TIMER).timeout
		set_process(false)
		self_modulate.a = 1

func recoil() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "position:x", start_pos.x+recoil_bounce*dir, 0.25).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "self_modulate", Color.RED, 0.25).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(self, "position:x", start_pos.x, 0.125).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "self_modulate", Color.WHITE, 0.25).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

func action_slide() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "position:x", start_pos.x-recoil_bounce*dir, 0.5).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:x", start_pos.x, 0.4).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)

func _on_data_acting() -> void:
	action_slide()

func _on_data_defeated() -> void:
	pass
