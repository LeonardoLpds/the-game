extends CenterContainer

export(Resource) var skill setget set_skill
export(String) var action

onready var skill_texture = $SkillTexture
onready var key = $Control/Key

func _ready() -> void:
	if (action):
		key.text = InputMap.get_action_list(action)[0].as_text()

func can_drop_data(_position: Vector2, data) -> bool:
	return data is Skill

func drop_data(_position: Vector2, data) -> void:
	self.skill = data

func set_skill(data: Skill) -> void:
	skill = data
	if skill is Skill:
		skill_texture.texture = skill.texture
		skill.shortcut = action
	else:
		skill_texture.texture = null
