extends Area2D

var floatingText = preload("res://src/characters/overlaps/FloatingText.tscn")

func _on_Hurtbox_area_entered(area):
	var parent = get_parent()
	var damage = area.damage if "damage" in area else 1
	if parent.has_method("hurt"):
		var output_damage = get_parent().hurt(damage)
		var text = floatingText.instance()
		text.amount = output_damage
		add_child(text)
