class_name Util extends Node

const SCREEN_FLASH: PackedScene = preload("res://Util/screen_flash.tscn")

static func set_keys_to_names(dict: Dictionary) -> void:
	var keys: Array = dict.keys()
	if dict[keys[0]] is RefCounted:
		for key in keys:
			dict[key].set_name_custom(key)
	else:
		print("ERR Dictionary must have instanced refrences in it.")

static func screen_flash(node: Node, animation: String, use_owner: bool) -> ScreenFlash:
	var inst: ScreenFlash = SCREEN_FLASH.instantiate()
	if use_owner and node.owner != null:
		node.owner.add_child(inst)
	else:
		node.add_child(inst)
	inst.play(animation)
	return inst

static func get_enum_key_at_index(enumerator: Dictionary, index: int) -> String:
	return enumerator.keys()[index]

static func choose(choices: Array):
	return choices[randi() % choices.size()]

static func choose_weighted(choices: Array, weights: Array):
	var temp_array: Array = []
	for i in choices.size()-1:
		for j in weights[i]:
			temp_array.append(choices[i])
	return choose(temp_array)

static func interweave_arrays(arr1: Array, arr2: Array) -> Array:
	var arr3: Array = []
	var min_size: int = 0
	
	if arr1.size() > arr2.size():
		min_size = arr1.size()
	else:
		min_size = arr2.size()
	for i in range(min_size):
		if arr1[i]:
			arr3.append(arr1[i])
		if arr2[i]:
			arr3.append(arr2[i])
	return arr3

static func get_four_directions() -> Array:
	return [Vector2.UP, Vector2.LEFT,Vector2.DOWN, Vector2.RIGHT]

static func get_surrounding_cell_orthogonal(cell: Vector2) -> Array:
	var surrounding_cells: Array = []
	var target_cell: Vector2
	
	for dir in get_four_directions():
		target_cell = cell+dir
		surrounding_cells.append(target_cell)
	
	return surrounding_cells

static func timer_is_running(timer: Timer) -> bool:
	return !timer.is_stopped()
