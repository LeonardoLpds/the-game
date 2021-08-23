extends KinematicBody2D

const WALK_SPEED = 130
const ACCELERATION = 20

var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _physics_process(_delta):
	var x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	var input = Vector2(x, y).normalized()
	
	if input != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input)
		animationTree.set("parameters/Run/blend_position", input)
		animationState.travel("Run")
		velocity = velocity.move_toward(input * WALK_SPEED, ACCELERATION)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION)

	velocity = move_and_slide(velocity)
