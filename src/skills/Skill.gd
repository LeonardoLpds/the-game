extends Resource
class_name Skill

enum TYPE { BUFF, PASSIVE, OFFENSIVE, HEAL, DEBUFF }

export(String) var id
export(String) var name
export(String) var description
export(Texture) var icon
export(Array, String) var skill_requirements
export(int) var player_level_require
export(int) var base_sp_cost
export(int) var max_level
export(int) var level
export(float) var base_cast_time
export(int) var base_damage
export(String) var debuff
export(Item.TYPE) var weapon_type
export(String) var shortcut

func _init(skill_id = null):
	if !skill_id:
		return
	if skill_id in SkillsData.skills:
		var skill = SkillsData.skills[skill_id];
		for key in skill:
			self[key] = skill[key]
