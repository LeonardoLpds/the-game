extends Node

var skills = {}

func _ready():
	var file = File.new()
	file.open("res://data/skills.json", File.READ)
	var json = JSON.parse(file.get_as_text())
	skills = json.result
	file.close()
