extends KinematicBody2D

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
const WALK_SPEED = 120
const ACCELERATION = 15
var velocity = Vector2.ZERO


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
		animationTree.set("parameters/Attack/blend_position", input)
		animationState.travel("Run")
		velocity = velocity.move_toward(input * WALK_SPEED, ACCELERATION)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION)

	velocity = move_and_slide(velocity)

	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func attack_state():
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	$SlashWeapon/Sword/AnimationPlayer.play("Attack Down")


func reset_state():
	state = MOVE
