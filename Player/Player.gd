extends KinematicBody2D

# Animations
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

# States
enum {
	MOVE,
	ATTACK
}
var state = MOVE

# Move variables
const WALK_SPEED = 130
const ACCELERATION = 20
var velocity = Vector2.ZERO

# Attack variables
var AttackAnimation = 1
var maxAttack = 2

func _ready():
	animationTree.active = true

func _physics_process(_delta):
	match state:
		MOVE:
			move_state()
		ATTACK:
			attack_state()

func move_state():
	var x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	var input = Vector2(x, y).normalized()
	
	if input != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input)
		animationTree.set("parameters/Run/blend_position", input)
		animationTree.set("parameters/Attack 1/blend_position", input)
		animationTree.set("parameters/Attack 2/blend_position", input)
		animationState.travel("Run")
		velocity = velocity.move_toward(input * WALK_SPEED, ACCELERATION)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION)

	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		if $AttackTimer.time_left > 0 && AttackAnimation < maxAttack:
			AttackAnimation = AttackAnimation + 1
		else:
			AttackAnimation = 1
			
		$AttackTimer.start()
		state = ATTACK

func attack_state():
	velocity = Vector2.ZERO
	animationState.travel("Attack " + str(AttackAnimation))
		
	
func reset_state():
	state = MOVE
