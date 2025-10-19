class_name Overworld extends Node2D

signal enemy_encountered(enemies_weighted: Array)
signal transition_entered(destination: String, exit_cell: Vector2, exit_facing: Vector2)

@export var spawn_facing: Math.Facing = Math.Facing.DOWN

@onready var danger: Danger = $Danger
@onready var main_map: MainMap = $MainMap
@onready var enemy_spawn_areas: EnemySpawnAreas = $EnemySpawnAreas
@onready var player: Player = %Player
@onready var transition: TransitionArea = get_node_or_null("Transition")

func _enter_tree() -> void:
	await get_tree().process_frame
	player.enable(true)
	player.set_facing(Math.convert_facing_int_to_vector2(spawn_facing), true)

func _on_player_moved(pos: Vector2, run_factor: float) -> void:
	var destination: String = main_map.get_tile_transistion_destination(pos)
	if !transition:
		if destination:
			transition_entered.emit(destination, GlobalScript.NULL_CELL, GlobalScript.NULL_CELL)
		else:
			danger.countdown(int(main_map.get_threat_level(pos) * run_factor))

func _on_danger_limit_reached() -> void:
	var enemies_weighted: Array = enemy_spawn_areas.get_enemies_weighted_at_cell(player.position)
	enemy_encountered.emit(enemies_weighted)

func _on_transition_transitioning(body: Node2D, destination: String) -> void:
	var facing_vector: Vector2 = Math.convert_facing_int_to_vector2(transition.exit_facing)
	if body is Player:
		transition_entered.emit(destination, transition.exit_cell, facing_vector)
