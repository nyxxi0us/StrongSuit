class_name EnemySpawnAreas extends TileMapLayer

const AREAS_WEIGHTED: Array = [
	[
		"Alp", 1,
		"Oni", 1,
		"Fae", 1,
	],
	[
		"Alp", 2,
		"Oni", 1,
		"Fae", 2,
	],
	[
		"Alp", 1,
		"Oni", 2,
		"Fae", 2,
	],
	[
		"Alp", 2,
		"Oni", 3,
		"Fae", 1,
	]
]

func  _ready() -> void:
	hide()

func  get_enemies_weighted_at_cell(pos: Vector2) -> Array:
	var cell: Vector2 = local_to_map(pos)
	var autotile_width: int = 4
	var atlas_coord: Vector2 = get_cell_atlas_coords(cell)
	var area_index: int = int(atlas_coord.x + atlas_coord.y * autotile_width)
	return AREAS_WEIGHTED[area_index % AREAS_WEIGHTED.size()]
