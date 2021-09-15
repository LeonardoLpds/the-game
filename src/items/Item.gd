extends Resource
class_name Item

export(int) var id
export(String) var name
export(Texture) var texture
export(int) var price

var amount = 1

func _init(item_id = null):
	if !item_id:
		return
	for item in ItemsData.items:
		if item.id == item_id:
			id = item.id
			name = item.name
			texture = load("res://assets/art/items/"+ item.name +".png")
