class_name GameController extends Node2D

var is_running: bool = true

enum GameState {
	PLAYER_TURN,
	ENEMY_TURN,
	DEFEAT,
	VICTORY,
	PAUSE,
}

@onready var current_state: GameState = GameState.PLAYER_TURN
var state_before_paused: GameState

func pause() -> void:
	is_running = false
	state_before_paused = current_state
	transition(GameState.PAUSE)

func resume() -> void:
	is_running = true
	transition(state_before_paused)

func transition(next_state: GameState) -> void:
	match current_state:
		GameState.PLAYER_TURN:
			pass
		GameState.ENEMY_TURN:
			pass
		GameState.DEFEAT:
			pass
		GameState.VICTORY:
			pass
	current_state = next_state
	match current_state:
		GameState.PLAYER_TURN:
			pass
		GameState.ENEMY_TURN:
			pass
		GameState.DEFEAT:
			pass
		GameState.VICTORY:
			pass
