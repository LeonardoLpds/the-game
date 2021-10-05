extends CanvasLayer

onready var inventory = preload("res://src/ui/iventory/scenes/Inventory.tscn").instance()
onready var skill_tree = preload("res://src/ui/skills/skill_tree/SkillTree.tscn").instance()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("bag"):
		if inventory.is_inside_tree():
			remove_child(inventory)
		else:
			add_child(inventory)

	if event.is_action_pressed("skills"):
		if skill_tree.is_inside_tree():
			remove_child(skill_tree)
		else:
			add_child(skill_tree)
