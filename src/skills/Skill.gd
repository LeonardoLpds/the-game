extends Resource
class_name Skill

enum TYPE { BUFF, PASSIVE, OFFENSIVE, HEAL, DEBUFF }

export(String) var id
export(String) var name
export(String) var description
export(Texture) var texture
export(Array, String) var skills_required
export(int) var player_level_required
export(int) var base_sp_cost
export(int) var max_level
export(int) var level
export(int) var base_damage
export(Item.TYPE) var weapon_type
export(String) var shortcut

func _init(skill_id = null):
	if !skill_id:
		return
	if skill_id in SkillsData.skills:
		var skill = SkillsData.skills[skill_id];
		id = skill_id
		for key in skill:
			self[key] = skill[key]
		texture = load("res://assets/art/skills/"+ SkillsData.skills[skill_id].name +".png")
