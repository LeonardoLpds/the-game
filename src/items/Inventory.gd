extends Resource
class_name Inventory


export(int) var inventory_size := 8
var items := []
var drag_data = null

signal items_changed(indexes)

func _init():
	items.resize(inventory_size)

func set_item(item_index: int, item: Item):
	print("set")
	print(item)
	var previous_item = items[item_index]
	items[item_index] = item
	emit_signal("items_changed", [item_index])
	return previous_item
	
func swap_items(item_index: int, target_index: int):
	var target_item = items[target_index]
	var item = items[item_index]
	items[target_index] = item
	items[item_index] = target_item
	emit_signal("items_changed", [item_index, target_index])

func remove_item(item_index: int):
	return set_item(item_index, null)

func add_item(item: Item):
	for item_index in inventory_size:
		if items[item_index] == null:
			items[item_index] = item
			emit_signal("items_changed", [item_index])
			return true
		elif items[item_index].id == item.id:
			items[item_index].amount += item.amount
			emit_signal("items_changed", [item_index])
			return true

