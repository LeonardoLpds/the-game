extends CenterContainer

export(int, "Not Connected", "Connect Left", "Connect Right", "Connect Up") var connector

export(String) var skill_id: String

onready var skill_button = $SkillButton
onready var skill_up = $SkillUp/Arrow
onready var level_label = $SkillLevel/Level
onready var connectors = [$Connectors/LeftConnector, $Connectors/RightConnector, $Connectors/UpConnector]

var skill : Skill

signal point_added

func _ready() -> void:
	if (skill_id):
		skill = Skill.new(skill_id)
		skill_button.texture_normal = skill.texture
	if (connector):
		connectors[connector - 1].visible = true

func enable_level_up() -> void:
	if skill == null:
		return
	skill_up.visible = true
	skill_button.disabled = false

func disable_level_up() -> void:
	skill_up.visible = false
	skill_button.disabled = true

func set_level(level: String) -> void:
	level_label.text = level
	
func get_drag_data(_position: Vector2) -> Skill:
	if skill is Skill and skill.level > 0:
		var drag_preview = TextureRect.new()
		drag_preview.texture = skill_button.texture_normal
		set_drag_preview(drag_preview)
		return skill
	return null

func _on_SkillButton_pressed() -> void:
	emit_signal("point_added", skill, self)

