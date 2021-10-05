extends Resource
class_name SkillBag

export(Array, Resource) var skills := []

func has_skill(skill: Skill):
	for i in skills:
		if (skill is Skill and i.id == skill.id):
			return true
	return false
