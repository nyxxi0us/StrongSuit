class_name TransitionArea extends Area2D

@export var destination: String = "Overworld"
@export var exit_cell: Vector2 = Vector2.ZERO
@export var exit_facing: Math.Facing = Math.Facing.DOWN

signal transitioning(body: Node2D, destination: String)

func _on_body_exited(body: Node2D) -> void:
	transitioning.emit(body, destination)
	
