extends CenterContainer

onready var item_texture = $ItemTexture
onready var label = $Control/Label

export(int) var index := 0
export(Resource) var inventory
export(Item.TYPE, FLAGS) var type_restriction

func display(item: Item) -> void:
	if item == null:
		item_texture.texture = null
		label.text = '';
	else:
		item_texture.texture = item.texture
		label.text = str(item.amount) if item.stackable else ''

func get_drag_data(_position: Vector2):
	var item = inventory.remove_item(index)
	if item is Item:
		var drag_preview = TextureRect.new()
		drag_preview.texture = item.texture
		set_drag_preview(drag_preview)
		var data = {"item": item, "item_index": index, "inventory": inventory, "type_restriction": type_restriction}
		inventory.drag_data = data
		return data

func can_drop_data(_position: Vector2, data) -> bool:
	if data is Dictionary and data.has("item"):
		var my_item = inventory.items[index]
		return _check_type(data.item.type) \
			and (_check_type(my_item.type, data.type_restriction) if my_item else true)
	return false

func drop_data(_position: Vector2, data) -> void:
	var my_item = inventory.items[index]
	
	if my_item is Item and my_item.id == data.item.id and my_item.stackable:
		inventory.add_item_quantity(index, data.item.amount)
	else:
		data.inventory.set_item(data.item_index, my_item)
		inventory.set_item(index, data.item)

	data.inventory.drag_data = null
	
func _check_type(type: int, mask = type_restriction) -> bool:
	if (mask):
		return mask & (1 << type) != 0
	return true
