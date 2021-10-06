extends Resource
class_name SkillBag

export(Array, Resource) var skills := []

func has_skill(skill: Skill) -> bool:
	return get_skill(skill) is Skill
	
func get_skill(skill: Skill) -> Skill:
	for i in skills:
		if skill is Skill and i.id == skill.id:
			return i
	return null

func get_skill_index(skill: Skill) -> int:
	for index in skills.size():
		if skill is Skill and skills[index - 1].id == skill.id:
			return index
	return -1

func can_learn(skill: Skill) -> bool:
	var self_skill = get_skill(skill)
	if self_skill == null:
		return true
	return self_skill.level < self_skill.max_level

func add_skill(skill: Skill) -> void:
	var skill_index = get_skill_index(skill)
	if skill_index < 0:
		skills.push_front(skill)
	else:
		skills[skill_index] = skill
