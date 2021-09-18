extends Position2D

export(String) var item_id := "BoVqkBaHQb7k7x4uEYgy"
var item_scene = preload("res://src/items/scenes/Item.tscn")

func dropLoot():
	var scene = item_scene.instance()
	scene.item = Item.new(item_id)
	scene.global_position = global_position
	owner.get_parent().add_child(scene)
