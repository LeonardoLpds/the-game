extends "res://src/characters/Character.gd"

onready var playerDetection = $PlayerDetectionZone
onready var wanderController = $WanderController

# Attributes
export var aggressive := true
export var walk_speed := 70
export var acceleration := 5

var velocity := Vector2.ZERO

# State Machine
enum {IDLE, WANDER, CHASE, ATTACK}
var state = WANDER

func _physics_process(_delta):
	match state:
		IDLE:
			idle_state()
			set_random_state([IDLE, WANDER])
			seek_player()
		WANDER:
			wander_state()
			set_random_state([IDLE, WANDER])
			seek_player()
		CHASE:
			chase_state()
	
	velocity = move_and_slide(velocity)
	
# States
func idle_state():
	velocity = Vector2.ZERO

func wander_state():
	velocity = velocity.move_toward(
		Steering.seek(velocity, global_position, wanderController.target_position, walk_speed, [self]),
		acceleration
	)
	
	
func chase_state():
	if playerDetection.is_player_in_range():
		velocity = velocity.move_toward(
			Steering.seek(velocity, global_position, playerDetection.player.global_position, walk_speed, [self, playerDetection.player]),
			acceleration
		)
	else:
		state = IDLE
	
# Helpers
func set_random_state(list: Array):
	if wanderController.is_time_over():
		list.shuffle()
		state = list[0]
		wanderController.start_timer(rand_range(1, 3))
	
func seek_player():
	if playerDetection.is_player_in_range():
		state = CHASE

# Signals
func _on_Enemy_no_hp():
	pass
