extends Resource
class_name Inventory

export(int) var inventory_size := 8 setget change_size
var items := []
var drag_data = null

signal items_changed(indexes)

func _init():
	items.resize(inventory_size)

func change_size(size: int):
	inventory_size = size
	items.resize(size)

func set_item(item_index: int, item: Item):
	var previous_item = items[item_index]
	items[item_index] = item
	emit_signal("items_changed", [item_index])
	return previous_item
	
func add_item_quantity(item_index: int, amount: int):
	if items[item_index].stackable:
		items[item_index].amount += amount
		emit_signal("items_changed", [item_index])

func remove_item(item_index: int):
	return set_item(item_index, null)

func add_item(item: Item):
	for item_index in inventory_size:
		if items[item_index] == null:
			items[item_index] = item
			emit_signal("items_changed", [item_index])
			return true
		elif items[item_index].id == item.id and items[item_index].stackable:
			items[item_index].amount += item.amount
			emit_signal("items_changed", [item_index])
			return true

