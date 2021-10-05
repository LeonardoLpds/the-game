extends NinePatchRect

onready var player = get_tree().get_nodes_in_group("player")[0]
onready var points_number = $MarginContainer/VBoxContainer/Details/VBoxContainer/PointsNumber
onready var apply_button = $MarginContainer/VBoxContainer/Details/Apply
onready var cancel_button = $MarginContainer/VBoxContainer/Details/Cancel

onready var points_to_spend = player.skill_points
onready var skill_nodes = get_tree().get_nodes_in_group("skill_icon")

func _ready() -> void:
	points_number.text = str(points_to_spend)
	if points_to_spend > 1:
		apply_button.disabled = false
		cancel_button.disabled = false
		for skill_node in skill_nodes:
			if !player.skills.has_skill(skill_node.skill):
				skill_node.enable_level_up()
	
