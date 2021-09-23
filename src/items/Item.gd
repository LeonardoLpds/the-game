extends Resource
class_name Item

enum TYPE { MISC, SWORD, AXE, BOW, STAFF, HEADGEAR, ARMOR, OFFHAND, ACESSORY, FOOTGEAR }

export(String) var id
export(String) var name
export(Texture) var animation
export(Texture) var texture
export(int) var price
export(TYPE) var type := TYPE.MISC
export(bool) var stackable := true
export(int) var amount := 1
export(int) var attack: int
export(int) var level: int

func _init(item_id = null):
	if !item_id:
		return
	if item_id in ItemsData.items:
		var item = ItemsData.items[item_id]
		id = item_id
		name = item.name
		price = item.price
		type = item.type
		stackable = item.stackable
		attack = item.attack if "attack" in item else 0
		level = item.attack if "level" in item else 0

		texture = load("res://assets/art/items/"+ ItemsData.items[item_id].name +".png")
		if File.new().file_exists("res://assets/art/items/"+ ItemsData.items[item_id].name +" animation.png"):
			animation = load("res://assets/art/items/"+ ItemsData.items[item_id].name +" animation.png")
