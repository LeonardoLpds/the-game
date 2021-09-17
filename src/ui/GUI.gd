extends CanvasLayer

onready var inventory = preload("res://src/ui/iventory/scenes/Inventory.tscn").instance()

func _ready():
	inventory.anchor_left = 0.25
	inventory.anchor_top = 0.25
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("bag"):
		if inventory.is_inside_tree():
			remove_child(inventory)
		else:
			add_child(inventory)
