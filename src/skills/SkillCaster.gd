extends Node

const SKILLS_PATH := "res://src/skills/scenes/"

signal not_enough_sp
signal wrong_weapon

func cast(skill: Skill) -> void:
	var skill_path : String = SKILLS_PATH + skill.name.capitalize().replacen(' ', '')  + ".tscn"

	if File.new().file_exists(skill_path):
		var caster : Character = get_parent()
		var skill_scene : SkillScene = load(skill_path).instance()
		skill_scene.resource = skill
		skill_scene.caster = get_parent()
		
		if (caster.weapon.type != skill.weapon_type):
			emit_signal("wrong_weapon")
			caster.reset_state()
			return

		if (skill_scene.sp_cost >= caster.sp):
			emit_signal("not_enough_sp")
			caster.reset_state()
			return

		caster.sp -= skill_scene.sp_cost

		get_parent().get_parent().add_child(skill_scene)
