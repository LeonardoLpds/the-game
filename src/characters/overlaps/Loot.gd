extends Position2D

export(int) var item_id := 1
var item_scene = preload("res://src/items/scenes/Item.tscn")

func dropLoot():
	var scene = item_scene.instance()
	scene.item = Item.new(item_id)
	scene.global_position = global_position
	owner.get_parent().add_child(scene)
