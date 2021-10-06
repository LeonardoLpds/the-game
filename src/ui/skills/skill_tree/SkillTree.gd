extends NinePatchRect

onready var player = get_tree().get_nodes_in_group("player")[0]
onready var points_number = $MarginContainer/VBoxContainer/Details/VBoxContainer/PointsNumber

onready var points_to_spend = player.skill_points
onready var skill_nodes = get_tree().get_nodes_in_group("skill_icon")

func _ready() -> void:
	for skill_node in skill_nodes:
		skill_node.connect("point_added", self, "_on_point_added")
	player.connect("skill_points_changed", self, "_on_points_changed")
	_update_tree()
	
func _update_tree() -> void:
	points_number.text = str(points_to_spend)
	for skill_node in skill_nodes:
		if points_to_spend >= 1 and player.skills.can_learn(skill_node.skill):
			skill_node.enable_level_up()
		else:
			skill_node.disable_level_up()
# Signals
func _on_points_changed(points: int) -> void:
	points_to_spend = points
	_update_tree()

func _on_point_added(skill: Skill, skill_node: Node) -> void:
	var player_skill = player.skills.get_skill(skill)
	if (player_skill == null):
		player_skill = skill
	
	player_skill.level += 1
	skill_node.set_level(str(player_skill.level))
	player.skills.add_skill(player_skill)
	
	player.spend_skill_points()
