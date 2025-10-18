class_name Math extends Node

const CIRCLE_RADIANS: float = 6.28

enum Facing {
	DOWN,
	LEFT,
	RIGHT,
	UP
}

static func get_random_rotation() -> float:
	return randf_range(0, CIRCLE_RADIANS)

static func approach(val1, val2, amount):
	var value
	if val1 < val2:
		value = min(val1 + amount, val2)
	elif val1 > val2:
		value = max(val1 - amount, val2)
	else:
		value = val1
	return value

static func convert_in_to_cm(value, step: float) -> float:
		return snappedf(value * 2.54, step)

static func convert_lb_to_kg(value, step: float) -> float:
		return snappedf(value * 0.453592, step)

static func add_with_random_spreadi(value: int, spread: int) -> int:
	return value + randi_range(-spread, spread)

static func add_with_random_spreadf(value: float, spread: float) -> float:
	return value + randf_range(-spread, spread)

static func get_four_direction_vector(diagonal_allowed: bool) -> Vector2:
	var velocity: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	elif Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if diagonal_allowed or is_zero_approx(velocity.x):
		if Input.is_action_pressed("ui_up"):
			velocity.y -= 1
		if Input.is_action_pressed("ui_down"):
			velocity.y += 1
	
	return velocity

static func get_analog_vector()-> Vector2:
	return Input.get_vector("ui_left","ui_right","ui_up", "ui_down") 

static func get_random_vector(snap: bool = false, min_x: float = -1.0, max_x: float = 1.0, min_y: float = -1.0, max_y: float = 1.0) -> Vector2:
	var vector: Vector2 = Vector2(randf_range(min_x,max_x),randf_range(min_y,max_y))
	if snap:
		vector.x = round(vector.x)
		vector.y = round(vector.y)
	return vector

static func get_random_vector_1d() -> Vector2:
	return Util.choose(Util.get_four_directions())

static func convert_vector2_to_facing_int(dir: Vector2) -> int:
	match dir:
		Vector2.UP:
			return Facing.UP
		Vector2.DOWN:
			return Facing.DOWN
		Vector2.RIGHT:
			return Facing.RIGHT
		Vector2.LEFT:
			return Facing.LEFT
		
	return Facing.DOWN

static func convert_facing_int_to_vector2(n:int) -> Vector2:
	match n:
		Facing.UP:
			return Vector2.UP
		Facing.DOWN:
			return Vector2.DOWN
		Facing.RIGHT:
			return Vector2.RIGHT
		Facing.LEFT:
			return Vector2.LEFT
		
	return Vector2.DOWN

static func convert_vector2_to_facing_string(dir: Vector2) -> String:
	var value: int = convert_vector2_to_facing_int(dir)
	var keys: Array = Facing.keys()
	for key in keys:
		if Facing[key] == value:
			return key
	return ""
