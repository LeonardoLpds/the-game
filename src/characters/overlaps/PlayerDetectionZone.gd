extends Area2D

var player = null
const DEFAULT_RADIUS = 80

onready var collisionShape = $CollisionShape2D

func is_player_in_range():
	return player != null
	
func increase_radius(radius: int):
	collisionShape.shape.radius = radius
	
func reset_radius():
	collisionShape.shape.radius = DEFAULT_RADIUS

func _on_PlayerDetectionZone_body_entered(body):
	player = body

func _on_PlayerDetectionZone_body_exited(_body):
	player = null
