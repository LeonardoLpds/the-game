extends Area2D

export(int) var damage := 1

func _physics_process(delta: float) -> void:
	var speed = 250 * delta
	global_position += Vector2(speed,0).rotated(rotation)

func _on_Arrow_area_entered(area: Area2D) -> void:
	queue_free()

func _on_Arrow_body_entered(body: Node) -> void:
	queue_free()
