extends Node2D

onready var start_position = global_position
onready var target_position = global_position
onready var timer = $Timer

func update_target_position():
	target_position = start_position + Vector2(rand_range(-32, 32), rand_range(-32, 32))

func start_timer(duration: float):
	timer.start(duration)

func is_time_over():
	return timer.time_left == 0

func _on_Timer_timeout():
	update_target_position()
