extends Area2D

export(int) var damage := 1
export(PackedScene) var free_effect;

func _physics_process(delta: float) -> void:
	var speed = 250 * delta
	global_position += Vector2(speed,0).rotated(rotation)

func _on_Arrow_area_entered(_area: Area2D) -> void:
	_finish()

func _on_Arrow_body_entered(_body: Node) -> void:
	_finish()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _finish():
	if free_effect != null:
		var effect = free_effect.instance()
		effect.global_position = global_position
		get_parent().add_child(effect)
	queue_free()
