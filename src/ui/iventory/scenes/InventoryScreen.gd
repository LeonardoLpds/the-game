extends Control

var slot_display_scene = preload("res://src/ui/iventory/scenes/SlotDisplay.tscn")
var player_bag = preload("res://src/characters/player/PlayerBag.tres")

onready var grid = $IventoryContainer/CenterContainer/GridContainer

var displays := []

func _ready():
	player_bag.connect("items_changed", self, "_on_item_changed")
	for item_index in player_bag.inventory_size:
		grid.add_child(slot_display_scene.instance())
	_update_all_slots()

func _on_item_changed(indexes: Array):
	for item_index in indexes:
		_update_inventory_slot(item_index)

func _update_inventory_slot(item_index: int):
	var slot_display = grid.get_child(item_index)
	var item = player_bag.items[item_index]
	slot_display.display_item(item)

func _update_all_slots():
	for item_index in player_bag.inventory_size:
		_update_inventory_slot(item_index)

func _unhandled_input(event):
	if event.is_action_released("ui_left_click"):
		if player_bag.drag_data is Dictionary:
			player_bag.set_item(player_bag.drag_data.item_index, player_bag.drag_data.item)
