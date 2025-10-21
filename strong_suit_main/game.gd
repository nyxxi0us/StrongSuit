class_name Game extends Node2D

var _battle: PackedScene = preload("res://Battle Scene/battle.tscn")

@onready var overworld: Overworld = $Overworld
@onready var canvas_layer_0: CanvasLayer = $CanvasLayer0
@onready var fade_transition: FadeTransition = $FadeTransition
@onready var battle_holder: CanvasLayer = $BattleHolder
@onready var current_scene: Node = overworld

var in_scene: bool

func transition_scene(scene: Node, spawn_cell: Vector2, spawn_facing: Vector2) -> void:
	GlobalScript.player.enable(false)
	if !in_scene:
		var fade_duration: float = 0.1 if scene is Battle else 0.5
		if scene != overworld  and scene is not Battle:
			scene.connect("transition_entered", _on_overworld_transition_entered)
		in_scene = true
		fade_transition.fade_in(Color.BLACK,fade_duration)
		await fade_transition.finished
		
		remove_child(current_scene)
		fade_transition.fade_out(Color.BLACK,fade_duration)
		
		if scene is Battle:
			battle_holder.add_child(scene)
			await  scene.tree_exiting
			call_deferred("add_child", current_scene)
			GlobalScript.player = overworld.player
		elif !scene.is_ancestor_of(self):
			add_child(scene)
			current_scene = scene
		
	if !spawn_cell.is_equal_approx(GlobalScript.NULL_CELL):
		GlobalScript.player.global_position = overworld.main_map.map_to_local(spawn_cell)
	if !spawn_facing.is_equal_approx(GlobalScript.NULL_CELL):
		GlobalScript.player.set_facing(spawn_facing,true)
	GlobalScript.player.enable(true)
	in_scene = false

func _on_overworld_enemy_encountered(enemies_weighted: Array) -> void:
	GlobalScript.player.enable(false)
	await Util.screen_flash(canvas_layer_0, "BATTLE_START", false).tree_exited
	var scene: Battle = _battle.instantiate()
	scene.enemies_weighted = enemies_weighted
	transition_scene(scene, GlobalScript.NULL_CELL, GlobalScript.NULL_CELL)

func _on_overworld_transition_entered(destination: String, exit_cell: Vector2, exit_facing: Vector2) -> void:
	if destination == overworld.name:
		transition_scene(overworld, exit_cell, exit_facing)
	else:
		var scene: Node = load("res://World/Areas/"+ destination.to_lower()+ ".tscn").instantiate()
		transition_scene(scene, exit_cell, exit_facing)
