extends Area2D

var target = null

export(int) var damage := 1

func _on_Hitbox_body_entered(body):
	print(body)
	target = body

func _on_Hitbox_body_exited(body):
	target = null
	
func is_target_on_range():
	return target != null
