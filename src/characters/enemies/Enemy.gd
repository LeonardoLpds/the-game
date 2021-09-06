extends "res://src/characters/Character.gd"

onready var playerDetection = $PlayerDetectionZone
onready var wanderController = $WanderController
onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite
onready var hitbox = $HitboxPivot/Hitbox
onready var pivot = $HitboxPivot

# Attributes
export var aggressive := true
export var walk_speed := 70
export var acceleration := 5

var velocity := Vector2.ZERO

# State Machine
enum {IDLE, WANDER, CHASE, ATTACK, HURT, DIE}
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
		HURT:
			hurt_state()
		DIE:
			die_state()
		ATTACK:
			attack_state()
	
	if velocity != Vector2.ZERO:
		sprite.flip_h = velocity.x < 0
		pivot.rotation_degrees = 180 if velocity.x < 0 else 0
		
	
	velocity = move_and_slide(velocity)
	
# States
func idle_state():
	$AnimationPlayer.play("Idle")
	velocity = velocity.move_toward(Vector2.ZERO, acceleration)

func wander_state():
	velocity = velocity.move_toward(
		Steering.seek(velocity, global_position, wanderController.target_position, walk_speed, [self]),
		acceleration
	)
	if velocity != Vector2.ZERO:
		$AnimationPlayer.play("Walk")
	else:
		$AnimationPlayer.play("Idle")
	
	
func chase_state():
	if playerDetection.is_player_in_range():
		$AnimationPlayer.play("Walk")
		velocity = velocity.move_toward(
			Steering.seek(velocity, global_position, playerDetection.player.global_position, walk_speed, [self, playerDetection.player]),
			acceleration
		)
		
		if hitbox.is_target_on_range():
			state = ATTACK
	else:
		state = IDLE
		
func hurt_state():
	velocity = velocity.move_toward(Vector2.ZERO, acceleration)
	animationPlayer.play("Hurt")

func die_state():
	set_physics_process(false)
	velocity = velocity.move_toward(Vector2.ZERO, acceleration)
	animationPlayer.play("Die")
	
func attack_state():
	velocity = velocity.move_toward(Vector2.ZERO, acceleration)
	$AnimationPlayer.play("Attack")

# Helpers
func set_random_state(list: Array):
	if wanderController.is_time_over():
		list.shuffle()
		state = list[0]
		wanderController.start_timer(rand_range(1, 3))
	
func seek_player():
	if playerDetection.is_player_in_range():
		state = CHASE
		
func reset_state():
	state = IDLE

# Signals
func _on_Enemy_no_hp():
	state = DIE

func _on_Enemy_hurt():
	state = HURT
