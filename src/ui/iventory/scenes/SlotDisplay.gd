extends CenterContainer

onready var item_texture = $ItemTexture
onready var label = $ItemTexture/AmountLabel

var player_bag = preload("res://src/characters/player/PlayerBag.tres")
var empty_slot = preload("res://assets/art/items/empty.png")
export(bool) var is_equip := false

func display_item(item: Item):
	if item == null:
		item_texture.texture = null
		label.text = ""
	else:
		item_texture.texture = item.texture
		label.text = str(item.amount)

func get_drag_data(_position):
	var item_index = get_index()
	var item = player_bag.remove_item(item_index)
	if item is Item:
		var drag_preview = TextureRect.new()
		drag_preview.texture = item.texture
		set_drag_preview(drag_preview)
		var data = {"item": item, "item_index": item_index}
		player_bag.drag_data = data
		return data

func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")
	
func drop_data(_position, data):
	var my_index = get_index()
	var my_item = player_bag.items[my_index]
	if my_item is Item and my_item.id == data.item.id:
		my_item.amount += data.item.amount
		player_bag.emit_signal("items_changed", [my_index])
	else:
		player_bag.swap_items(my_index, data.item_index)
		player_bag.set_item(my_index, data.item)
	player_bag.drag_data = null
