extends CenterContainer

onready var item_texture = $ItemTexture
onready var label = $Control/Label

export(int) var index := 0
export(Resource) var inventory

func display(item: Item) -> void:
	if item == null:
		item_texture.texture = null
		label.text = '';
	else:
		item_texture.texture = item.texture
		label.text = str(item.amount);

func get_drag_data(_position: Vector2):
	var item = inventory.remove_item(index)
	if item is Item:
		var drag_preview = TextureRect.new()
		drag_preview.texture = item.texture
		set_drag_preview(drag_preview)
		var data = {"item": item, "item_index": index, "inventory": inventory}
		inventory.drag_data = data
		return data

func can_drop_data(position: Vector2, data) -> bool:
	return data is Dictionary and data.has("item")

func drop_data(position: Vector2, data) -> void:
	var my_item = inventory.items[index]
	if my_item is Item and my_item.id == data.item.id:
		inventory.add_item_quantity(index, data.item.amount)
	else:
		inventory.set_item(index, data.item)
		data.inventory.set_item(data.item_index, my_item)
	data.inventory.drag_data = null
