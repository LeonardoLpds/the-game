extends CenterContainer

export(String) var skill_id: String

onready var skill_texture = $SkillTexture
onready var skill_up = $SkillUp/Arrow

var skill : Skill

func _ready() -> void:
	if (skill_id):
		skill = Skill.new(skill_id)
		skill_texture.texture = skill.texture

func enable_level_up():
	skill_up.visible = true
