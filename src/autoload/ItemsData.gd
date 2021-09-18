extends Node

var items = {}

func _ready():
	var file = File.new()
	file.open("res://data/items.json", File.READ)
	var json = JSON.parse(file.get_as_text())
	items = json.result
	file.close()
