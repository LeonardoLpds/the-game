extends Area2D

var floatingText = preload("res://src/characters/overlaps/FloatingText.tscn")
var blood = preload("res://src/effects/Blood.tscn")

func _on_Hurtbox_area_entered(area: Area2D):
	var new_pos = area.global_position - global_position
	var parent = get_parent()
	var damage = area.damage if "damage" in area else 1
	if parent.has_method("hurt"):
		var output_damage = get_parent().hurt(damage)
		var text = floatingText.instance()
		text.amount = output_damage
		var blood_effect = blood.instance()
		blood_effect.process_material.direction = Vector3(new_pos.x, new_pos.y, 0) * -1
		add_child(blood_effect)
		add_child(text)
