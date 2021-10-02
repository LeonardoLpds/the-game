extends Node2D
class_name SkillScene

var caster: Character
var resource: Skill

var sp_cost setget ,get_sp

func get_sp() -> int:
	return int(floor(resource.base_sp_cost * (1 + resource.level * 0.01)))
