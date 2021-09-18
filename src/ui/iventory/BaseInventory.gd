extends Node
class_name BaseInventory

export(Resource) var inventory

func _ready() -> void:
	inventory.connect("items_changed", self, "_on_items_changed")
	
func _on_items_changed(indexes: Array) -> void:
	for item_index in indexes:
		_update_slot(item_index)
		
func _update_slot(item_index: int):
	var slot = _get_slot(item_index)
	var item = inventory.items[item_index]
	slot.display(item)
	
func _get_slot(_index: int):
	pass

func _update_all_slots() ->void:
	for item_index in inventory.inventory_size:
		_update_slot(item_index)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("ui_left_click") and inventory.drag_data is Dictionary:
		inventory.set_item(inventory.drag_data.item_index, inventory.drag_data.item)
