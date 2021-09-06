extends Node2D

const MAX_SPEED := 70.0
var mass := 10.0
var num_rays := 8

const RAYS := []

func _ready():
	RAYS.resize(num_rays)

	for i in num_rays:
		var angle = i * 2 * PI / num_rays
		RAYS[i] = {"direction": Vector2.RIGHT.rotated(angle), "score": 0}

func seek(
	velocity: Vector2,
	current_position: Vector2,
	target: Vector2,
	max_speed := MAX_SPEED,
	ignore_collider := []
) -> Vector2:
	if current_position.distance_to(target) < 5:
		return Vector2.ZERO

	var desired_direction := (target - current_position).normalized()
	set_direction_score(desired_direction, max_speed, current_position, ignore_collider)
	
	var chosen_direction = Vector2.ZERO
	for i in num_rays:
		chosen_direction += RAYS[i].direction * RAYS[i].score
		
	var desired_velocity = chosen_direction.normalized() * max_speed
	var steering = (desired_velocity - velocity) / mass
	return velocity + steering

func set_direction_score(desired_direction: Vector2, max_speed: float, current_position: Vector2, ignore_collider: Array) -> void:
	var look_ahead = max_speed / 4
	var space_state = get_world_2d().direct_space_state

	for i in num_rays:
		RAYS[i].score = max(0, RAYS[i].direction.dot(desired_direction))
		
		var collision = space_state.intersect_ray(
			current_position, current_position + RAYS[i].direction * look_ahead,
			ignore_collider
		)
		if !collision.empty():
			var collision_dot_product = collision.position.normalized().dot(current_position.normalized())
			RAYS[i].score = max(0, RAYS[i].score - collision_dot_product)
