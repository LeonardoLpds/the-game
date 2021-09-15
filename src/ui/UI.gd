extends CanvasLayer

var inventory_screen = preload("res://src/ui/iventory/scenes/InventoryScreen.tscn").instance()

func _ready():
	pass

func _input(event):
	if event.is_action_pressed("bag"):
		if inventory_screen.is_inside_tree():
			remove_child(inventory_screen)
		else:
			add_child(inventory_screen)
