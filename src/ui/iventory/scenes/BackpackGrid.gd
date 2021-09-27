extends BaseInventory

var slot_scene = preload("res://src/ui/iventory/scenes/Slot.tscn")

func _ready() -> void:
	for item_index in inventory.inventory_size:
		var slot_instance = slot_scene.instance()
		slot_instance.inventory = inventory
		slot_instance.index = get_child_count()
		add_child(slot_instance)
	._update_all_slots()
	inventory.add_item(Item.new("XiQqkxrEFJqNjY7rhz9A"))
	inventory.add_item(Item.new("YAAi86AWspYOhT6boW1r"))
	inventory.add_item(Item.new("3AafJi61VL3vv0UTvnZb"))
	inventory.add_item(Item.new("Cqy0q6tTkMogXvratASR"))

func _get_slot(index: int):
	return get_child(index)
