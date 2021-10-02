extends Character

onready var playerDetection = $PlayerDetectionZone
onready var wanderController = $WanderController
onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite
onready var hitbox = $HitboxPivot/Hitbox
onready var hurtbox = $Hurtbox
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
	animationPlayer.play("Idle")
	velocity = velocity.move_toward(Vector2.ZERO, acceleration)

func wander_state():
	velocity = velocity.move_toward(
		Steering.seek(velocity, global_position, wanderController.target_position, walk_speed, [self]),
		acceleration
	)
	if velocity != Vector2.ZERO:
		animationPlayer.play("Walk")
	else:
		animationPlayer.play("Idle")
	
	
func chase_state():
	if playerDetection.is_player_in_range():
		animationPlayer.play("Walk")
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
	if !playerDetection.is_player_in_range():
		playerDetection.increase_radius(300)

func die_state():
	set_physics_process(false)
	hitbox.get_node("CollisionShape2D").disabled = true
	hurtbox.get_node("CollisionShape2D").disabled = true
	
	velocity = velocity.move_toward(Vector2.ZERO, acceleration)
	animationPlayer.play("Die")
	yield(animationPlayer, "animation_finished")
	if has_node("Loot"):
		get_node("Loot").dropLoot()
	queue_free()
	
	
func attack_state():
	playerDetection.reset_radius()
	velocity = velocity.move_toward(Vector2.ZERO, acceleration)
	animationPlayer.play("Attack")

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

func _on_Enemy_attack_change():
	call_deferred("_set_hitbox_damage")

func _set_hitbox_damage():
	hitbox.damage = self.attack
