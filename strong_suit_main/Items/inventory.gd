class_name Inventory extends Resource

signal item_updated(item, index)

enum {
	DEALER,
	SMITH,
	MYSTIC,
	LIBRARIAN,
	PLAYER
}

var item_lists: Dictionary[int,Array] = {
	DEALER: [["Dice", "Chip", "Rand. Card"],[2,3,1]],
	SMITH: [["Rand. Card", "Notch", "Rand. Wnd. Card", "Rand. Whl. Card", "Rand. Mrr. Card", "Rand. Dgr. Card"],[3,3,2,2,2,2]],
	MYSTIC: [["Tarot Reading"],[3]],
	LIBRARIAN: [["Tome of Spark", "Tome of Focus", "Tome of Stitch", "Tome of Prayer"],[1,1,1,1]],
	PLAYER: [["Notch", "Sleeve", "Foil"],[2,4,3]]
}
var items: Array[Item] = []
var type: int = -1

func _init(_type: int = type) -> void:
	type = _type
	var item_names: Array = item_lists[type][0]
	var item_quantities: Array = item_lists[type][1]
	add_array_items_by_name(item_names,item_quantities)

func add_item(new_item: Item) -> void:
	if !new_item:
		return
	for item in items:
		if item.name == new_item.name:
			item.quantity += new_item.quantity
			return
	
	var item: Item = new_item.duplicate_custom()
	items.append(item)
	item_updated.emit(item, items.size()-1)

func add_item_by_name(item_name: String, amount: int) -> void:
	var item: Item = Data.items[item_name]
	for i in amount:
		add_item(item)

func add_array_items_by_name(item_names: Array, amounts: Array) -> void:
	for i in range(item_names.size()):
		add_item_by_name(item_names[i], amounts[i])

func remove_item(_item: Item, quantity: int) -> void:
	var item: Item = get_item_by_name(_item.name)
	var index: int = items.find(item)
	item.quantity -= quantity
	if item.quantity <= 0:
		items.remove_at(index)
	item_updated.emit(item, index)

func remove_item_by_index(n: int, quantity: int) -> void:
	var item: Item = items[n]
	item.quantity -= quantity
	if item.quantity <= 0:
		items.remove_at(n)
	item_updated.emit(item, n)

func get_item_by_name(item_name: String) -> Item:
	var new_item: Item = null
	for item in items:
		if item.name == item_name:
			new_item = item
			break
	return new_item

func get_item_by_index(n: int) -> Item:
	if n < items.size():
		return items[n]
	return null

func sort_items() -> void:
	items.sort_custom(func(a, b): return a.name.naturalnocasecmp_to(b.name) < 0)

func get_items() -> Array:
	return items

func has_item(item: Item) -> bool:
	return items.has(item)

func get_item_names() -> Array:
	var name_array: Array = []
	for item in items:
		name_array.append(item.name)
	return name_array

func empty() -> bool:
	return items.is_empty()
