extends Area2D

func _on_Hurtbox_area_entered(area):
	var parent = get_parent()
	if parent.has_method("hurt"):
		get_parent().hurt(area.damage if "damage" in area else 1)
