extends CenterContainer

export(String) var skill_id: String

onready var skill_button = $SkillButton
onready var skill_up = $SkillUp/Arrow
onready var level_label = $SkillLevel/Level

var skill : Skill

signal point_added

func _ready() -> void:
	if (skill_id):
		skill = Skill.new(skill_id)
		skill_button.texture_normal = skill.texture

func enable_level_up() -> void:
	skill_up.visible = true
	skill_button.disabled = false

func disable_level_up() -> void:
	skill_up.visible = false
	skill_button.disabled = true

func set_level(level: String) -> void:
	level_label.text = level

func _on_SkillButton_pressed() -> void:
	emit_signal("point_added", skill, self)

